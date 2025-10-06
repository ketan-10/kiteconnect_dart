/// Models for KiteTicker WebSocket streaming
library;

/// Market depth data
class Depth {
  /// Number of orders
  final int orders;

  /// Price at this depth level
  final double price;

  /// Quantity at this depth level
  final int quantity;

  Depth({
    required this.orders,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        'orders': orders,
        'price': price,
        'quantity': quantity,
      };

  @override
  String toString() => 'Depth(orders: $orders, price: $price, quantity: $quantity)';
}

/// Market depth with buy and sell sides
class MarketDepth {
  /// Buy side depth (bids)
  final List<Depth> buy;

  /// Sell side depth (offers)
  final List<Depth> sell;

  MarketDepth({
    required this.buy,
    required this.sell,
  });

  Map<String, dynamic> toJson() => {
        'buy': buy.map((d) => d.toJson()).toList(),
        'sell': sell.map((d) => d.toJson()).toList(),
      };

  @override
  String toString() => 'MarketDepth(buy: $buy, sell: $sell)';
}

/// OHLC (Open, High, Low, Close) data
class OHLC {
  /// Opening price
  final double open;

  /// Highest price
  final double high;

  /// Lowest price
  final double low;

  /// Closing price
  final double close;

  OHLC({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  Map<String, dynamic> toJson() => {
        'open': open,
        'high': high,
        'low': low,
        'close': close,
      };

  @override
  String toString() => 'OHLC(open: $open, high: $high, low: $low, close: $close)';
}

/// Base class for all tick types
abstract class Tick {
  /// Tick mode (ltp, quote, or full)
  final String mode;

  /// Whether the instrument is tradable
  final bool tradable;

  /// Instrument token
  final int instrumentToken;

  Tick({
    required this.mode,
    required this.tradable,
    required this.instrumentToken,
  });

  Map<String, dynamic> toJson();
}

/// LTP (Last Traded Price) tick
class LTPTick extends Tick {
  /// Last traded price
  final double lastPrice;

  LTPTick({
    required super.instrumentToken,
    required super.tradable,
    required this.lastPrice,
  }) : super(mode: 'ltp');

  @override
  Map<String, dynamic> toJson() => {
        'mode': mode,
        'tradable': tradable,
        'instrument_token': instrumentToken,
        'last_price': lastPrice,
      };

  @override
  String toString() =>
      'LTPTick(instrument_token: $instrumentToken, last_price: $lastPrice)';
}

/// Quote tick with OHLC and change
class QuoteTick extends Tick {
  /// Last traded price
  final double lastPrice;

  /// OHLC data
  final OHLC ohlc;

  /// Percentage change from close
  final double change;

  /// Exchange timestamp (optional)
  final DateTime? exchangeTimestamp;

  QuoteTick({
    required super.instrumentToken,
    required super.tradable,
    required this.lastPrice,
    required this.ohlc,
    required this.change,
    this.exchangeTimestamp,
  }) : super(mode: 'quote');

  @override
  Map<String, dynamic> toJson() => {
        'mode': mode,
        'tradable': tradable,
        'instrument_token': instrumentToken,
        'last_price': lastPrice,
        'ohlc': ohlc.toJson(),
        'change': change,
        if (exchangeTimestamp != null)
          'exchange_timestamp': exchangeTimestamp!.toIso8601String(),
      };

  @override
  String toString() =>
      'QuoteTick(instrument_token: $instrumentToken, last_price: $lastPrice, change: $change)';
}

/// Full mode tick with all available data
class FullTick extends Tick {
  /// Last traded price
  final double lastPrice;

  /// Last traded quantity
  final int lastTradedQuantity;

  /// Average traded price
  final double averageTradePrice;

  /// Volume traded today
  final int volumeTradedToday;

  /// Total buy quantity
  final int totalBuyQuantity;

  /// Total sell quantity
  final int totalSellQuantity;

  /// OHLC data
  final OHLC ohlc;

  /// Percentage change from close
  final double change;

  /// Last trade time (optional)
  final DateTime? lastTradeTime;

  /// Exchange timestamp (optional)
  final DateTime? exchangeTimestamp;

  /// Open Interest (optional, futures/options only)
  final int? oi;

  /// Open Interest day high (optional)
  final int? oiDayHigh;

  /// Open Interest day low (optional)
  final int? oiDayLow;

  /// Market depth (optional, only in full mode)
  final MarketDepth? depth;

  FullTick({
    required super.instrumentToken,
    required super.tradable,
    required this.lastPrice,
    required this.lastTradedQuantity,
    required this.averageTradePrice,
    required this.volumeTradedToday,
    required this.totalBuyQuantity,
    required this.totalSellQuantity,
    required this.ohlc,
    required this.change,
    this.lastTradeTime,
    this.exchangeTimestamp,
    this.oi,
    this.oiDayHigh,
    this.oiDayLow,
    this.depth,
  }) : super(mode: 'full');

  @override
  Map<String, dynamic> toJson() => {
        'mode': mode,
        'tradable': tradable,
        'instrument_token': instrumentToken,
        'last_price': lastPrice,
        'last_traded_quantity': lastTradedQuantity,
        'average_traded_price': averageTradePrice,
        'volume_traded': volumeTradedToday,
        'total_buy_quantity': totalBuyQuantity,
        'total_sell_quantity': totalSellQuantity,
        'ohlc': ohlc.toJson(),
        'change': change,
        if (lastTradeTime != null)
          'last_trade_time': lastTradeTime!.toIso8601String(),
        if (exchangeTimestamp != null)
          'exchange_timestamp': exchangeTimestamp!.toIso8601String(),
        if (oi != null) 'oi': oi,
        if (oiDayHigh != null) 'oi_day_high': oiDayHigh,
        if (oiDayLow != null) 'oi_day_low': oiDayLow,
        if (depth != null) 'depth': depth!.toJson(),
      };

  @override
  String toString() =>
      'FullTick(instrument_token: $instrumentToken, last_price: $lastPrice, volume: $volumeTradedToday)';
}
