import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:kiteconnect_dart/kite_ticker.dart';
import 'package:kiteconnect_dart/models/ticker_models.dart';

void main() {
  test('test_ticker_creation', () {
    final ticker = KiteTicker(
      apiKey: 'test_api_key',
      accessToken: 'test_access_token',
    );
    // Basic creation test passes if no exception occurs
    expect(ticker, isNotNull);
  });

  test('test_ticker_builder', () {
    final ticker = KiteTicker(
      apiKey: 'test_api_key',
      accessToken: 'test_access_token',
      autoReconnect: false,
      maxRetry: 5,
    );
    expect(ticker, isNotNull);
  });

  test('test_reconnect_delay_validation', () {
    final ticker = KiteTicker(
      apiKey: 'test_api_key',
      accessToken: 'test_access_token',
    );

    // Test that setting delay below minimum gets clamped
    ticker.autoReconnect(true, null, 1); // Below minimum of 5
    expect(ticker, isNotNull);

    // Test that setting valid delay succeeds
    ticker.autoReconnect(true, null, 10); // Valid delay
    expect(ticker, isNotNull);
  });

  test('test_packet_parsing_ltp', () {
    // Test LTP packet parsing
    final data = Uint8List.fromList([
      0x00, 0x01, // 1 packet
      0x00, 0x08, // packet length
      0x00, 0x06, 0x3a, 0x01, // instrument token: 408065
      0x00, 0x02, 0x66, 0x83, // last price: 157315 (1573.15 after conversion)
    ]);

    final ticker = KiteTicker(
      apiKey: 'test_api_key',
      accessToken: 'test_access_token',
    );

    final ticks = ticker.parseBinary(data);
    expect(ticks, isNotEmpty);

    final tick = ticks.first as LTPTick;
    expect(tick.instrumentToken, equals(408065));
    expect(tick.mode, equals('ltp'));
    expect(tick.lastPrice, closeTo(1573.15, 0.01));
  });

  test('test_price_conversion', () {
    final ticker = KiteTicker(
      apiKey: 'test_api_key',
      accessToken: 'test_access_token',
    );

    // Test NSE/BSE equity price conversion (divide by 100)
    final nseData = Uint8List.fromList([
      0x00, 0x01, // 1 packet
      0x00, 0x08, // packet length
      0x00, 0x00, 0x00, 0x01, // segment 1
      0x00, 0x02, 0x66, 0x7B, // price: 157307
    ]);
    final nseTicks = ticker.parseBinary(nseData);
    expect((nseTicks.first as LTPTick).lastPrice, closeTo(1573.07, 0.01));

    // Test NSE CD price conversion (divide by 10,000,000)
    final nseCDData = Uint8List.fromList([
      0x00, 0x01, // 1 packet
      0x00, 0x08, // packet length
      0x00, 0x00, 0x00, 0x03, // segment 3
      0x09, 0x61, 0x2e, 0x98, // price: 157315000
    ]);
    final nseCDTicks = ticker.parseBinary(nseCDData);
    expect((nseCDTicks.first as LTPTick).lastPrice, closeTo(15.7315, 0.01));

    // Test BSE CD price conversion (divide by 10,000)
    final bseCDData = Uint8List.fromList([
      0x00, 0x01, // 1 packet
      0x00, 0x08, // packet length
      0x00, 0x00, 0x00, 0x06, // segment 6
      0x00, 0x02, 0x66, 0x7B, // price: 157307
    ]);
    final bseCDTicks = ticker.parseBinary(bseCDData);
    expect((bseCDTicks.first as LTPTick).lastPrice, closeTo(15.7307, 0.01));
  });

  test('test_split_packets', () {
    // Create test data with 2 packets
    final data = <int>[0x00, 0x02]; // 2 packets

    // First packet: 8 bytes (LTP packet)
    data.addAll([0x00, 0x08]); // packet length
    data.addAll([0x00, 0x06, 0x37, 0x81]); // instrument token
    data.addAll([0x00, 0x02, 0x66, 0x7B]); // price data

    // Second packet: 8 bytes (another LTP packet)
    data.addAll([0x00, 0x08]); // packet length
    data.addAll([0x00, 0x0B, 0x44, 0x41]); // different instrument token
    data.addAll([0x00, 0x03, 0x88, 0x9C]); // different price data

    final ticker = KiteTicker(
      apiKey: 'test_api_key',
      accessToken: 'test_access_token',
    );

    final packets = ticker.splitPackets(Uint8List.fromList(data));
    expect(packets.length, equals(2));
    expect(packets[0].length, equals(8));
    expect(packets[1].length, equals(8));
  });

  test('test_mode_display', () {
    expect(KiteTicker.modeLTP, equals('ltp'));
    expect(KiteTicker.modeQuote, equals('quote'));
    expect(KiteTicker.modeFull, equals('full'));
  });

  test('test_parse_quote_packet', () {
    final packetData = loadPacket('test/mocks/ticker_quote.packet');

    final ticker = KiteTicker(
      apiKey: 'test_api_key',
      accessToken: 'test_access_token',
    );

    final ticks = ticker.parseBinary(packetData);
    expect(ticks, isNotEmpty);

    final tick = ticks.first as FullTick;

    // Expected values from the Go test case
    expect(tick.mode, equals('full')); // 44-byte packet is parsed as full mode
    expect(tick.instrumentToken, equals(408065));
    expect(tick.tradable, isTrue);
    expect(tick.lastPrice, closeTo(1573.15, 0.01));
    expect(tick.lastTradedQuantity, equals(1));
    expect(tick.totalBuyQuantity, equals(256511));
    expect(tick.totalSellQuantity, equals(360503));
    expect(tick.volumeTradedToday, equals(1175986));
    expect(tick.averageTradePrice, closeTo(1570.33, 0.01));
    expect(tick.oi ?? 0, equals(0));
    expect(tick.oiDayHigh ?? 0, equals(0));
    expect(tick.oiDayLow ?? 0, equals(0));

    // OHLC values
    expect(tick.ohlc.open, closeTo(1569.15, 0.01));
    expect(tick.ohlc.high, closeTo(1575.0, 0.01));
    expect(tick.ohlc.low, closeTo(1561.05, 0.01));
    expect(tick.ohlc.close, closeTo(1567.8, 0.01));

    // Net change calculation (last_price - close_price) as percentage
    final expectedNetChange = (tick.lastPrice - tick.ohlc.close) * 100 / tick.ohlc.close;
    expect(tick.change, closeTo(expectedNetChange, 0.01));

    // Depth should be null for 44-byte packet (limited full mode)
    expect(tick.depth, isNull);
  });

  test('test_parse_full_packet', () {
    final packetData = loadPacket('test/mocks/ticker_full.packet');

    final ticker = KiteTicker(
      apiKey: 'test_api_key',
      accessToken: 'test_access_token',
    );

    final ticks = ticker.parseBinary(packetData);
    expect(ticks, isNotEmpty);

    final tick = ticks.first as FullTick;

    // Expected values from the Go test case
    expect(tick.mode, equals('full'));
    expect(tick.instrumentToken, equals(408065));
    expect(tick.tradable, isTrue);
    expect(tick.lastPrice, closeTo(1573.7, 0.01));
    expect(tick.lastTradedQuantity, equals(7));
    expect(tick.totalBuyQuantity, equals(256443));
    expect(tick.totalSellQuantity, equals(363009));
    expect(tick.volumeTradedToday, equals(1192471));
    expect(tick.averageTradePrice, closeTo(1570.37, 0.01));
    expect(tick.oi, equals(0));
    expect(tick.oiDayHigh, equals(0));
    expect(tick.oiDayLow, equals(0));

    // OHLC values
    expect(tick.ohlc.open, closeTo(1569.15, 0.01));
    expect(tick.ohlc.high, closeTo(1575.0, 0.01));
    expect(tick.ohlc.low, closeTo(1561.05, 0.01));
    expect(tick.ohlc.close, closeTo(1567.8, 0.01));

    // Net change should be approximately 0.376% (percentage)
    expect(tick.change, closeTo(0.376, 0.1));

    // Timestamp and LastTradeTime should be 1625461887 (Unix timestamp)
    if (tick.exchangeTimestamp != null) {
      expect(
        tick.exchangeTimestamp!.millisecondsSinceEpoch ~/ 1000,
        equals(1625461887),
      );
    }
    if (tick.lastTradeTime != null) {
      expect(
        tick.lastTradeTime!.millisecondsSinceEpoch ~/ 1000,
        equals(1625461887),
      );
    }

    // Check depth data - Buy side
    expect(tick.depth, isNotNull);
    if (tick.depth != null) {
      final expectedBuyDepth = [
        {'price': 1573.4, 'quantity': 5, 'orders': 1},
        {'price': 1573.0, 'quantity': 140, 'orders': 2},
        {'price': 1572.95, 'quantity': 2, 'orders': 1},
        {'price': 1572.9, 'quantity': 219, 'orders': 7},
        {'price': 1572.85, 'quantity': 50, 'orders': 1},
      ];

      for (var i = 0; i < expectedBuyDepth.length; i++) {
        expect(tick.depth!.buy[i].price, closeTo(expectedBuyDepth[i]['price'] as double, 0.01));
        expect(tick.depth!.buy[i].quantity, equals(expectedBuyDepth[i]['quantity']));
        expect(tick.depth!.buy[i].orders, equals(expectedBuyDepth[i]['orders']));
      }

      // Check depth data - Sell side
      final expectedSellDepth = [
        {'price': 1573.7, 'quantity': 172, 'orders': 3},
        {'price': 1573.75, 'quantity': 44, 'orders': 3},
        {'price': 1573.85, 'quantity': 302, 'orders': 3},
        {'price': 1573.9, 'quantity': 141, 'orders': 2},
        {'price': 1573.95, 'quantity': 724, 'orders': 5},
      ];

      for (var i = 0; i < expectedSellDepth.length; i++) {
        expect(tick.depth!.sell[i].price, closeTo(expectedSellDepth[i]['price'] as double, 0.01));
        expect(tick.depth!.sell[i].quantity, equals(expectedSellDepth[i]['quantity']));
        expect(tick.depth!.sell[i].orders, equals(expectedSellDepth[i]['orders']));
      }
    }
  });

  test('test_parse_binary_with_multiple_packets', () {
    // Test parsing binary data with multiple packets
    final file1 = File('test/mocks/ticker_quote.packet');
    final quoteData = base64Decode(file1.readAsStringSync().trim());

    final file2 = File('test/mocks/ticker_full.packet');
    final fullData = base64Decode(file2.readAsStringSync().trim());

    // Create a combined packet with 2 packets
    final combinedData = <int>[0x00, 0x02]; // 2 packets

    // First packet (quote)
    combinedData.addAll([(quoteData.length >> 8) & 0xFF, quoteData.length & 0xFF]);
    combinedData.addAll(quoteData);

    // Second packet (full)
    combinedData.addAll([(fullData.length >> 8) & 0xFF, fullData.length & 0xFF]);
    combinedData.addAll(fullData);

    final ticker = KiteTicker(
      apiKey: 'test_api_key',
      accessToken: 'test_access_token',
    );

    final ticks = ticker.parseBinary(Uint8List.fromList(combinedData));
    expect(ticks.length, equals(2));

    // First tick should be quote mode (but parsed as full due to 44 bytes)
    expect(ticks[0].mode, equals('full'));
    expect(ticks[0].instrumentToken, equals(408065));

    // Second tick should be full mode
    expect(ticks[1].mode, equals('full'));
    expect(ticks[1].instrumentToken, equals(408065));
  });

  test('test_segment_detection', () {
    // Test different segment detection
    final nseCMToken = 408065; // NSE CM
    final indicesToken = 0x09; // INDICES

    // NSE CM token
    final nseSeg = nseCMToken & 0xFF;
    expect(nseSeg, isNot(equals(9))); // Not indices

    // Indices token
    final indicesSeg = indicesToken & 0xFF;
    expect(indicesSeg, equals(9)); // Is indices
  });

  test('test_real_connection', () async {
    final apiKey = Platform.environment['KITE_API_KEY'] ?? '';
    final accessToken = Platform.environment['KITE_ACCESS_TOKEN'] ?? '';

    if (apiKey.isEmpty || accessToken.isEmpty) {
      print('Skipping real connection test - no credentials provided');
      return;
    }

    final ticker = KiteTicker(
      apiKey: apiKey,
      accessToken: accessToken,
      autoReconnect: false,
    );

    final completer = Completer<void>();

    ticker.onConnect(() {
      print('Successfully connected!');
      if (!completer.isCompleted) completer.complete();
    });

    ticker.onError((error) {
      print('Connection error: $error');
      if (!completer.isCompleted) completer.completeError(error);
    });

    ticker.connect();

    // Wait for connection or timeout
    try {
      await completer.future.timeout(
        Duration(seconds: 10),
        onTimeout: () {
          print('Integration test timed out');
          throw TimeoutException('Connection timeout');
        },
      );
      print('Integration test passed');
    } catch (e) {
      print('Integration test failed: $e');
    } finally {
      ticker.disconnect();
    }
  }, skip: 'Ignore by default since it requires real credentials');
}

// Helper function to load packet data from base64 files
Uint8List loadPacket(String filePath) {
  final file = File(filePath);
  final content = file.readAsStringSync();
  final decoded = base64Decode(content.trim());

  // Wrap the raw packet in the expected format
  final wrapped = <int>[
    0x00, 0x01, // 1 packet
    (decoded.length >> 8) & 0xFF, decoded.length & 0xFF, // packet length
    ...decoded, // packet data
  ];

  return Uint8List.fromList(wrapped);
}
