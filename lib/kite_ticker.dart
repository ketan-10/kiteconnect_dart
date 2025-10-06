/// KiteTicker - WebSocket client for streaming live market data from Kite Connect
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:kiteconnect_dart/constants.dart';
import 'package:kiteconnect_dart/models/ticker_models.dart';
import 'package:kiteconnect_dart/models/order_models.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';

/// WebSocket client for connecting to Kite Connect streaming quotes service
class KiteTicker {
  // Constants for market segments
  static const int nseCM = 1;
  static const int nseFO = 2;
  static const int nseCD = 3;
  static const int bseCM = 4;
  static const int bseFO = 5;
  static const int bseCD = 6;
  static const int mcxFO = 7;
  static const int mcxSX = 8;
  static const int indices = 9;

  // Tick modes
  static const String modeFull = 'full';
  static const String modeQuote = 'quote';
  static const String modeLTP = 'ltp';

  // Message types
  static const String _mSubscribe = 'subscribe';
  static const String _mUnSubscribe = 'unsubscribe';
  static const String _mSetMode = 'mode';

  // Configuration
  final String apiKey;
  final String accessToken;
  final String root;
  final int _readTimeout = 5;

  // Reconnection settings
  int _reconnectMaxDelay;
  int _reconnectMaxTries;
  bool _autoReconnect;
  bool _shouldReconnect = true;

  // Internal state
  WebSocketChannel? _ws;
  Timer? _readTimer;
  DateTime? _lastRead;
  String? _currentWsUrl;
  int _currentReconnectionCount = 0;
  int _lastReconnectInterval = 0;
  final Set<int> _subscribedTokens = {};
  final Map<int, String> _modeMap = {};

  // Event callbacks
  final List<void Function()> _onConnectCallbacks = [];
  final List<void Function(List<Tick>)> _onTicksCallbacks = [];
  final List<void Function(dynamic)> _onDisconnectCallbacks = [];
  final List<void Function(dynamic)> _onErrorCallbacks = [];
  final List<void Function(String)> _onCloseCallbacks = [];
  final List<void Function(int, int)> _onReconnectCallbacks = [];
  final List<void Function()> _onNoReconnectCallbacks = [];
  final List<void Function(Uint8List)> _onMessageCallbacks = [];
  final List<void Function(Order)> _onOrderUpdateCallbacks = [];

  // Default values
  static const int _defaultReconnectMaxDelay = 60;
  static const int _defaultReconnectMaxRetries = 50;
  static const int _maximumReconnectMaxRetries = 300;
  static const int _minimumReconnectMaxDelay = 5;

  /// Creates a new KiteTicker instance
  KiteTicker({
    required this.apiKey,
    required this.accessToken,
    String? root,
    bool autoReconnect = true,
    int? maxRetry,
    int? maxDelay,
  })  : root = root ?? 'wss://ws.kite.trade/',
        _autoReconnect = autoReconnect,
        _reconnectMaxTries = (maxRetry ?? _defaultReconnectMaxRetries)
            .clamp(0, _maximumReconnectMaxRetries),
        _reconnectMaxDelay =
            (maxDelay ?? _defaultReconnectMaxDelay) < _minimumReconnectMaxDelay
                ? _minimumReconnectMaxDelay
                : (maxDelay ?? _defaultReconnectMaxDelay);

  /// Configure auto-reconnection settings
  void autoReconnect(bool enabled, [int? maxRetry, int? maxDelay]) {
    _autoReconnect = enabled;
    if (maxRetry != null) {
      _reconnectMaxTries = maxRetry >= _maximumReconnectMaxRetries
          ? _maximumReconnectMaxRetries
          : maxRetry;
    }
    if (maxDelay != null) {
      _reconnectMaxDelay = maxDelay <= _minimumReconnectMaxDelay
          ? _minimumReconnectMaxDelay
          : maxDelay;
    }
  }

  /// Establishes a WebSocket connection
  void connect() {
    // Skip if already connected or connecting
    if (_ws != null) return;

    final url = '$root?api_key=$apiKey&access_token=$accessToken&uid=${DateTime.now().millisecondsSinceEpoch}';

    try {
      final uri = Uri.parse(url);
      final socket = WebSocket.connect(
        uri.toString(),
        headers: {
          'X-Kite-Version': AppConstants.kiteHeaderVersion,
          'User-Agent': '${AppConstants.kiteConnectName}/${AppConstants.kiteConnectVersion}',
        },
      );

      socket.then((ws) {
        _ws = IOWebSocketChannel(ws);
        _setupWebSocket();
        _currentWsUrl = url;

        // Reset reconnection state
        _lastReconnectInterval = 0;
        _currentReconnectionCount = 0;

        // Trigger connect event
        _trigger(_onConnectCallbacks);

        // Setup read timeout monitoring
        _lastRead = DateTime.now();
        _readTimer?.cancel();
        _readTimer = Timer.periodic(Duration(seconds: _readTimeout), (_) {
          if (_lastRead != null &&
              DateTime.now().difference(_lastRead!).inSeconds >= _readTimeout) {
            _currentWsUrl = null;
            _ws?.sink.close();
            _readTimer?.cancel();
            _triggerDisconnect(null);
          }
        });
      }).catchError((error) {
        _triggerError(error);
        if (_autoReconnect) {
          _attemptReconnection();
        }
      });
    } catch (e) {
      _triggerError(e);
    }
  }

  void _setupWebSocket() {
    _ws?.stream.listen(
      (message) {
        if (message is Uint8List) {
          // Binary message (tick data)
          for (final cb in _onMessageCallbacks) {
            cb(message);
          }

          if (message.length > 2) {
            final ticks = _parseBinary(message);
            if (ticks.isNotEmpty) {
              _trigger(_onTicksCallbacks, [ticks]);
            }
          }
        } else if (message is String) {
          // Text message (order updates, errors, etc.)
          _parseTextMessage(message);
        }

        _lastRead = DateTime.now();
      },
      onError: (error) {
        _triggerError(error);
        _ws?.sink.close();
      },
      onDone: () {
        final url = _currentWsUrl;
        _trigger(_onCloseCallbacks, ['Connection closed']);

        // Check if this is a ghost close event
        if (_currentWsUrl != null && url != _currentWsUrl) {
          return;
        }

        _triggerDisconnect(null);
      },
      cancelOnError: true,
    );
  }

  /// Attempts to reconnect
  void _attemptReconnection() {
    if (_currentReconnectionCount > _reconnectMaxTries || !_shouldReconnect) {
      _trigger(_onNoReconnectCallbacks);
      return;
    }

    if (_currentReconnectionCount > 0) {
      _lastReconnectInterval = 1 << _currentReconnectionCount; // 2^count
    } else if (_lastReconnectInterval == 0) {
      _lastReconnectInterval = 1;
    }

    if (_lastReconnectInterval > _reconnectMaxDelay) {
      _lastReconnectInterval = _reconnectMaxDelay;
    }

    _currentReconnectionCount++;
    _trigger(_onReconnectCallbacks, [_currentReconnectionCount, _lastReconnectInterval]);

    Timer(Duration(seconds: _lastReconnectInterval), () {
      connect();
    });
  }

  void _triggerDisconnect(dynamic error) {
    _ws = null;
    _trigger(_onDisconnectCallbacks, [error]);
    if (_autoReconnect) {
      _attemptReconnection();
    }
  }

  /// Closes the WebSocket connection
  void disconnect() {
    _shouldReconnect = false;
    _readTimer?.cancel();
    _ws?.sink.close();
    _ws = null;
  }

  /// Checks if the WebSocket connection is currently open
  bool get connected => _ws != null;

  /// Subscribe to list of instrument tokens
  List<int> subscribe(List<int> tokens) {
    if (tokens.isNotEmpty) {
      _send({'a': _mSubscribe, 'v': tokens});
      _subscribedTokens.addAll(tokens);
      for (final token in tokens) {
        _modeMap[token] = modeQuote;
      }
    }
    return tokens;
  }

  /// Unsubscribe from list of instrument tokens
  List<int> unsubscribe(List<int> tokens) {
    if (tokens.isNotEmpty) {
      _send({'a': _mUnSubscribe, 'v': tokens});
      _subscribedTokens.removeAll(tokens);
      for (final token in tokens) {
        _modeMap.remove(token);
      }
    }
    return tokens;
  }

  /// Set streaming mode for list of tokens
  List<int> setMode(String mode, List<int> tokens) {
    if (tokens.isNotEmpty) {
      _send({
        'a': _mSetMode,
        'v': [mode, tokens]
      });
      for (final token in tokens) {
        _modeMap[token] = mode;
      }
    }
    return tokens;
  }

  /// Send message through WebSocket
  void _send(Map<String, dynamic> message) {
    if (_ws == null) return;

    try {
      final jsonMessage = jsonEncode(message);
      _ws!.sink.add(jsonMessage);
    } catch (e) {
      _ws?.sink.close();
    }
  }

  /// Parse text messages (order updates, errors)
  void _parseTextMessage(String message) {
    try {
      final data = jsonDecode(message);
      if (data is! Map<String, dynamic>) return;

      final type = data['type'];
      if (type == 'order') {
        final order = Order.fromJson(data['data']);
        _trigger(_onOrderUpdateCallbacks, [order]);
      }
    } catch (e) {
      // Ignore parse errors
    }
  }

  /// Parse binary tick packets
  List<Tick> _parseBinary(Uint8List binpacks) {
    final packets = _splitPackets(binpacks);
    final ticks = <Tick>[];

    for (final bin in packets) {
      if (bin.length < 4) continue;

      final instrumentToken = _buf2long(bin.sublist(0, 4));
      final segment = instrumentToken & 0xff;
      final tradable = segment != indices;

      // Price divisor based on segment
      final divisor = segment == nseCD
          ? 10000000.0
          : segment == bseCD
              ? 10000.0
              : 100.0;

      if (bin.length == 8) {
        // LTP mode
        ticks.add(LTPTick(
          instrumentToken: instrumentToken,
          tradable: tradable,
          lastPrice: _buf2long(bin.sublist(4, 8)) / divisor,
        ));
      } else if (bin.length == 28 || bin.length == 32) {
        // Quote mode (indices or with timestamp)
        final lastPrice = _buf2long(bin.sublist(4, 8)) / divisor;
        final ohlc = OHLC(
          high: _buf2long(bin.sublist(8, 12)) / divisor,
          low: _buf2long(bin.sublist(12, 16)) / divisor,
          open: _buf2long(bin.sublist(16, 20)) / divisor,
          close: _buf2long(bin.sublist(20, 24)) / divisor,
        );

        final change = ohlc.close != 0 ? (lastPrice - ohlc.close) * 100 / ohlc.close : 0.0;

        DateTime? timestamp;
        if (bin.length == 32) {
          final ts = _buf2long(bin.sublist(28, 32));
          if (ts > 0) timestamp = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
        }

        ticks.add(QuoteTick(
          instrumentToken: instrumentToken,
          tradable: tradable,
          lastPrice: lastPrice,
          ohlc: ohlc,
          change: change,
          exchangeTimestamp: timestamp,
        ));
      } else if (bin.length == 44 || bin.length == 184) {
        // Full mode
        final lastPrice = _buf2long(bin.sublist(4, 8)) / divisor;
        final ohlc = OHLC(
          open: _buf2long(bin.sublist(28, 32)) / divisor,
          high: _buf2long(bin.sublist(32, 36)) / divisor,
          low: _buf2long(bin.sublist(36, 40)) / divisor,
          close: _buf2long(bin.sublist(40, 44)) / divisor,
        );

        final change = ohlc.close != 0 ? (lastPrice - ohlc.close) * 100 / ohlc.close : 0.0;

        DateTime? lastTradeTime;
        DateTime? exchangeTimestamp;
        int? oi;
        int? oiDayHigh;
        int? oiDayLow;
        MarketDepth? depth;

        if (bin.length == 184) {
          final ltt = _buf2long(bin.sublist(44, 48));
          if (ltt > 0) lastTradeTime = DateTime.fromMillisecondsSinceEpoch(ltt * 1000);

          final ts = _buf2long(bin.sublist(60, 64));
          if (ts > 0) exchangeTimestamp = DateTime.fromMillisecondsSinceEpoch(ts * 1000);

          oi = _buf2long(bin.sublist(48, 52));
          oiDayHigh = _buf2long(bin.sublist(52, 56));
          oiDayLow = _buf2long(bin.sublist(56, 60));

          // Parse market depth
          final depthBytes = bin.sublist(64, 184);
          final buyDepth = <Depth>[];
          final sellDepth = <Depth>[];

          for (int i = 0; i < 10; i++) {
            final s = i * 12;
            final depthItem = Depth(
              quantity: _buf2long(depthBytes.sublist(s, s + 4)),
              price: _buf2long(depthBytes.sublist(s + 4, s + 8)) / divisor,
              orders: _buf2long(depthBytes.sublist(s + 8, s + 10)),
            );

            if (i < 5) {
              buyDepth.add(depthItem);
            } else {
              sellDepth.add(depthItem);
            }
          }

          depth = MarketDepth(buy: buyDepth, sell: sellDepth);
        }

        ticks.add(FullTick(
          instrumentToken: instrumentToken,
          tradable: tradable,
          lastPrice: lastPrice,
          lastTradedQuantity: _buf2long(bin.sublist(8, 12)),
          averageTradePrice: _buf2long(bin.sublist(12, 16)) / divisor,
          volumeTradedToday: _buf2long(bin.sublist(16, 20)),
          totalBuyQuantity: _buf2long(bin.sublist(20, 24)),
          totalSellQuantity: _buf2long(bin.sublist(24, 28)),
          ohlc: ohlc,
          change: change,
          lastTradeTime: lastTradeTime,
          exchangeTimestamp: exchangeTimestamp,
          oi: oi,
          oiDayHigh: oiDayHigh,
          oiDayLow: oiDayLow,
          depth: depth,
        ));
      }
    }

    return ticks;
  }

  /// Split binary data into individual packets
  List<Uint8List> _splitPackets(Uint8List bin) {
    final packets = <Uint8List>[];
    final numPackets = _buf2long(bin.sublist(0, 2));
    int j = 2;

    for (int i = 0; i < numPackets; i++) {
      final size = _buf2long(bin.sublist(j, j + 2));
      final packet = bin.sublist(j + 2, j + 2 + size);
      packets.add(packet);
      j += 2 + size;
    }

    return packets;
  }

  /// Convert big-endian byte array to integer
  int _buf2long(Uint8List buf) {
    int val = 0;
    final len = buf.length;

    for (int i = 0; i < len; i++) {
      val += buf[len - 1 - i] << (i * 8);
    }

    return val;
  }

  /// Trigger callbacks
  void _trigger<T>(List<T> callbacks, [List<dynamic>? args]) {
    for (final callback in callbacks) {
      if (args == null || args.isEmpty) {
        (callback as Function)();
      } else if (args.length == 1) {
        (callback as Function)(args[0]);
      } else if (args.length == 2) {
        (callback as Function)(args[0], args[1]);
      }
    }
  }

  void _triggerError(dynamic error) {
    _trigger(_onErrorCallbacks, [error]);
  }

  // Event listener registration methods
  void onConnect(void Function() callback) => _onConnectCallbacks.add(callback);
  void onTicks(void Function(List<Tick>) callback) => _onTicksCallbacks.add(callback);
  void onDisconnect(void Function(dynamic) callback) => _onDisconnectCallbacks.add(callback);
  void onError(void Function(dynamic) callback) => _onErrorCallbacks.add(callback);
  void onClose(void Function(String) callback) => _onCloseCallbacks.add(callback);
  void onReconnect(void Function(int, int) callback) => _onReconnectCallbacks.add(callback);
  void onNoReconnect(void Function() callback) => _onNoReconnectCallbacks.add(callback);
  void onMessage(void Function(Uint8List) callback) => _onMessageCallbacks.add(callback);
  void onOrderUpdate(void Function(Order) callback) => _onOrderUpdateCallbacks.add(callback);

  // Public methods for testing
  /// Parse binary tick packets (exposed for testing)
  @visibleForTesting
  List<Tick> parseBinary(Uint8List binpacks) => _parseBinary(binpacks);

  /// Split binary data into individual packets (exposed for testing)
  @visibleForTesting
  List<Uint8List> splitPackets(Uint8List bin) => _splitPackets(bin);

  /// Convert big-endian byte array to integer (exposed for testing)
  @visibleForTesting
  int buf2long(Uint8List buf) => _buf2long(buf);
}
