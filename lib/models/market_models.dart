class OHLC {
  final double open;
  final double high;
  final double low;
  final double close;

  OHLC({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
  });

  factory OHLC.fromJson(Map<String, dynamic> json) => OHLC(
        open: (json['open'] as num).toDouble(),
        high: (json['high'] as num).toDouble(),
        low: (json['low'] as num).toDouble(),
        close: (json['close'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'open': open,
        'high': high,
        'low': low,
        'close': close,
      };
}

class DepthItem {
  final int quantity;
  final double price;
  final int orders;

  DepthItem({
    required this.quantity,
    required this.price,
    required this.orders,
  });

  factory DepthItem.fromJson(Map<String, dynamic> json) => DepthItem(
        quantity: json['quantity'],
        price: (json['price'] as num).toDouble(),
        orders: json['orders'],
      );

  Map<String, dynamic> toJson() => {
        'quantity': quantity,
        'price': price,
        'orders': orders,
      };
}

class Depth {
  final List<DepthItem> buy;
  final List<DepthItem> sell;

  Depth({
    required this.buy,
    required this.sell,
  });

  factory Depth.fromJson(Map<String, dynamic> json) => Depth(
        buy: (json['buy'] as List)
            .map((e) => DepthItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        sell: (json['sell'] as List)
            .map((e) => DepthItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'buy': buy.map((e) => e.toJson()).toList(),
        'sell': sell.map((e) => e.toJson()).toList(),
      };
}

class QuoteData {
  final int instrumentToken;
  final DateTime? timestamp;
  final double lastPrice;
  final int lastQuantity;
  final DateTime? lastTradeTime;
  final double averagePrice;
  final int volume;
  final int buyQuantity;
  final int sellQuantity;
  final OHLC ohlc;
  final double netChange;
  final double oi;
  final double oiDayHigh;
  final double oiDayLow;
  final double lowerCircuitLimit;
  final double upperCircuitLimit;
  final Depth depth;

  QuoteData({
    required this.instrumentToken,
    this.timestamp,
    required this.lastPrice,
    required this.lastQuantity,
    this.lastTradeTime,
    required this.averagePrice,
    required this.volume,
    required this.buyQuantity,
    required this.sellQuantity,
    required this.ohlc,
    required this.netChange,
    required this.oi,
    required this.oiDayHigh,
    required this.oiDayLow,
    required this.lowerCircuitLimit,
    required this.upperCircuitLimit,
    required this.depth,
  });

  factory QuoteData.fromJson(Map<String, dynamic> json) => QuoteData(
        instrumentToken: json['instrument_token'],
        timestamp: json['timestamp'] != null
            ? DateTime.parse(json['timestamp'])
            : null,
        lastPrice: (json['last_price'] as num).toDouble(),
        lastQuantity: json['last_quantity'],
        lastTradeTime: json['last_trade_time'] != null
            ? DateTime.parse(json['last_trade_time'])
            : null,
        averagePrice: (json['average_price'] as num).toDouble(),
        volume: json['volume'],
        buyQuantity: json['buy_quantity'],
        sellQuantity: json['sell_quantity'],
        ohlc: OHLC.fromJson(json['ohlc']),
        netChange: (json['net_change'] as num).toDouble(),
        oi: (json['oi'] as num).toDouble(),
        oiDayHigh: (json['oi_day_high'] as num).toDouble(),
        oiDayLow: (json['oi_day_low'] as num).toDouble(),
        lowerCircuitLimit: (json['lower_circuit_limit'] as num).toDouble(),
        upperCircuitLimit: (json['upper_circuit_limit'] as num).toDouble(),
        depth: Depth.fromJson(json['depth']),
      );

  Map<String, dynamic> toJson() => {
        'instrument_token': instrumentToken,
        if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
        'last_price': lastPrice,
        'last_quantity': lastQuantity,
        if (lastTradeTime != null)
          'last_trade_time': lastTradeTime!.toIso8601String(),
        'average_price': averagePrice,
        'volume': volume,
        'buy_quantity': buyQuantity,
        'sell_quantity': sellQuantity,
        'ohlc': ohlc.toJson(),
        'net_change': netChange,
        'oi': oi,
        'oi_day_high': oiDayHigh,
        'oi_day_low': oiDayLow,
        'lower_circuit_limit': lowerCircuitLimit,
        'upper_circuit_limit': upperCircuitLimit,
        'depth': depth.toJson(),
      };
}

typedef Quote = Map<String, QuoteData>;

class QuoteOHLCData {
  final int instrumentToken;
  final double lastPrice;
  final OHLC ohlc;

  QuoteOHLCData({
    required this.instrumentToken,
    required this.lastPrice,
    required this.ohlc,
  });

  factory QuoteOHLCData.fromJson(Map<String, dynamic> json) => QuoteOHLCData(
        instrumentToken: json['instrument_token'],
        lastPrice: (json['last_price'] as num).toDouble(),
        ohlc: OHLC.fromJson(json['ohlc']),
      );

  Map<String, dynamic> toJson() => {
        'instrument_token': instrumentToken,
        'last_price': lastPrice,
        'ohlc': ohlc.toJson(),
      };
}

typedef QuoteOHLC = Map<String, QuoteOHLCData>;

class QuoteLTPData {
  final int instrumentToken;
  final double lastPrice;

  QuoteLTPData({
    required this.instrumentToken,
    required this.lastPrice,
  });

  factory QuoteLTPData.fromJson(Map<String, dynamic> json) => QuoteLTPData(
        instrumentToken: json['instrument_token'],
        lastPrice: (json['last_price'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'instrument_token': instrumentToken,
        'last_price': lastPrice,
      };
}

typedef QuoteLTP = Map<String, QuoteLTPData>;

class HistoricalData {
  final DateTime? date;
  final double open;
  final double high;
  final double low;
  final double close;
  final int volume;
  final int oi;

  HistoricalData({
    this.date,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.oi,
  });

  factory HistoricalData.fromJson(Map<String, dynamic> json) =>
      HistoricalData(
        date: json['date'] != null ? DateTime.parse(json['date']) : null,
        open: (json['open'] as num).toDouble(),
        high: (json['high'] as num).toDouble(),
        low: (json['low'] as num).toDouble(),
        close: (json['close'] as num).toDouble(),
        volume: json['volume'],
        oi: json['oi'],
      );

  Map<String, dynamic> toJson() => {
        if (date != null) 'date': date!.toIso8601String(),
        'open': open,
        'high': high,
        'low': low,
        'close': close,
        'volume': volume,
        'oi': oi,
      };
}

class HistoricalDataParams {
  final String from;
  final String to;
  final bool continuous;
  final bool oi;

  HistoricalDataParams({
    required this.from,
    required this.to,
    required this.continuous,
    required this.oi,
  });

  factory HistoricalDataParams.fromJson(Map<String, dynamic> json) =>
      HistoricalDataParams(
        from: json['from'],
        to: json['to'],
        continuous: json['continuous'],
        oi: json['oi'],
      );

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'continuous': continuous,
        'oi': oi,
      };
}

class Instrument {
  final int instrumentToken;
  final int exchangeToken;
  final String tradingsymbol;
  final String name;
  final double lastPrice;
  final DateTime? expiry;
  final double strike;
  final double tickSize;
  final double lotSize;
  final String instrumentType;
  final String segment;
  final String exchange;

  Instrument({
    required this.instrumentToken,
    required this.exchangeToken,
    required this.tradingsymbol,
    required this.name,
    required this.lastPrice,
    this.expiry,
    required this.strike,
    required this.tickSize,
    required this.lotSize,
    required this.instrumentType,
    required this.segment,
    required this.exchange,
  });

  factory Instrument.fromJson(Map<String, dynamic> json) => Instrument(
        instrumentToken: json['instrument_token'],
        exchangeToken: json['exchange_token'],
        tradingsymbol: json['tradingsymbol'],
        name: json['name'],
        lastPrice: (json['last_price'] as num).toDouble(),
        expiry: json['expiry'] != null ? DateTime.parse(json['expiry']) : null,
        strike: (json['strike'] as num).toDouble(),
        tickSize: (json['tick_size'] as num).toDouble(),
        lotSize: (json['lot_size'] as num).toDouble(),
        instrumentType: json['instrument_type'],
        segment: json['segment'],
        exchange: json['exchange'],
      );

  Map<String, dynamic> toJson() => {
        'instrument_token': instrumentToken,
        'exchange_token': exchangeToken,
        'tradingsymbol': tradingsymbol,
        'name': name,
        'last_price': lastPrice,
        if (expiry != null) 'expiry': expiry!.toIso8601String(),
        'strike': strike,
        'tick_size': tickSize,
        'lot_size': lotSize,
        'instrument_type': instrumentType,
        'segment': segment,
        'exchange': exchange,
      };
}

typedef Instruments = List<Instrument>;

class MFInstrument {
  final String tradingsymbol;
  final String name;
  final double lastPrice;
  final String amc;
  final bool purchaseAllowed;
  final bool redemptionAllowed;
  final double minimumPurchaseAmount;
  final double purchaseAmountMultiplier;
  final double minimumAdditionalPurchaseAmount;
  final double minimumRedemptionQuantity;
  final double redemptionQuantityMultiplier;
  final String dividendType;
  final String schemeType;
  final String plan;
  final String settlementType;
  final DateTime? lastPriceDate;

  MFInstrument({
    required this.tradingsymbol,
    required this.name,
    required this.lastPrice,
    required this.amc,
    required this.purchaseAllowed,
    required this.redemptionAllowed,
    required this.minimumPurchaseAmount,
    required this.purchaseAmountMultiplier,
    required this.minimumAdditionalPurchaseAmount,
    required this.minimumRedemptionQuantity,
    required this.redemptionQuantityMultiplier,
    required this.dividendType,
    required this.schemeType,
    required this.plan,
    required this.settlementType,
    this.lastPriceDate,
  });

  factory MFInstrument.fromJson(Map<String, dynamic> json) => MFInstrument(
        tradingsymbol: json['tradingsymbol'],
        name: json['name'],
        lastPrice: (json['last_price'] as num).toDouble(),
        amc: json['amc'],
        purchaseAllowed: _boolFromInt(json['purchase_allowed']),
        redemptionAllowed: _boolFromInt(json['redemption_allowed']),
        minimumPurchaseAmount:
            (json['minimum_purchase_amount'] as num).toDouble(),
        purchaseAmountMultiplier:
            (json['purchase_amount_multiplier'] as num).toDouble(),
        minimumAdditionalPurchaseAmount:
            (json['minimum_additional_purchase_amount'] as num).toDouble(),
        minimumRedemptionQuantity:
            (json['minimum_redemption_quantity'] as num).toDouble(),
        redemptionQuantityMultiplier:
            (json['redemption_quantity_multiplier'] as num).toDouble(),
        dividendType: json['dividend_type'],
        schemeType: json['scheme_type'],
        plan: json['plan'],
        settlementType: json['settlement_type'],
        lastPriceDate: json['last_price_date'] != null
            ? DateTime.parse(json['last_price_date'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'tradingsymbol': tradingsymbol,
        'name': name,
        'last_price': lastPrice,
        'amc': amc,
        'purchase_allowed': purchaseAllowed ? 1 : 0,
        'redemption_allowed': redemptionAllowed ? 1 : 0,
        'minimum_purchase_amount': minimumPurchaseAmount,
        'purchase_amount_multiplier': purchaseAmountMultiplier,
        'minimum_additional_purchase_amount': minimumAdditionalPurchaseAmount,
        'minimum_redemption_quantity': minimumRedemptionQuantity,
        'redemption_quantity_multiplier': redemptionQuantityMultiplier,
        'dividend_type': dividendType,
        'scheme_type': schemeType,
        'plan': plan,
        'settlement_type': settlementType,
        if (lastPriceDate != null)
          'last_price_date': lastPriceDate!.toIso8601String(),
      };
}

typedef MFInstruments = List<MFInstrument>;

// Helper function to convert int (0/1) to bool
bool _boolFromInt(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value == '1';
  return false;
}
