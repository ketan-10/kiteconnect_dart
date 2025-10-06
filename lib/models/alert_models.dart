import 'market_models.dart';

enum AlertType {
  simple,
  ato;

  String toJson() => name;

  static AlertType fromJson(String json) =>
      AlertType.values.firstWhere((e) => e.name == json);
}

enum AlertStatus {
  enabled,
  disabled,
  deleted;

  String toJson() => name;

  static AlertStatus fromJson(String json) =>
      AlertStatus.values.firstWhere((e) => e.name == json);
}

enum AlertOperator {
  le('<='),
  ge('>='),
  lt('<'),
  gt('>'),
  eq('==');

  final String value;
  const AlertOperator(this.value);

  String toJson() => value;

  static AlertOperator fromJson(String json) =>
      AlertOperator.values.firstWhere((e) => e.value == json);
}

class Alert {
  final AlertType type;
  final String userId;
  final String uuid;
  final String name;
  final AlertStatus status;
  final String disabledReason;
  final String lhsAttribute;
  final String lhsExchange;
  final String lhsTradingsymbol;
  final AlertOperator operator;
  final String rhsType;
  final String rhsAttribute;
  final String rhsExchange;
  final String rhsTradingsymbol;
  final double? rhsConstant;
  final int? alertCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Basket? basket;

  Alert({
    required this.type,
    required this.userId,
    required this.uuid,
    required this.name,
    required this.status,
    required this.disabledReason,
    required this.lhsAttribute,
    required this.lhsExchange,
    required this.lhsTradingsymbol,
    required this.operator,
    required this.rhsType,
    required this.rhsAttribute,
    required this.rhsExchange,
    required this.rhsTradingsymbol,
    this.rhsConstant,
    this.alertCount,
    this.createdAt,
    this.updatedAt,
    this.basket,
  });

  factory Alert.fromJson(Map<String, dynamic> json) => Alert(
        type: AlertType.fromJson(json['type']),
        userId: json['user_id'],
        uuid: json['uuid'],
        name: json['name'],
        status: AlertStatus.fromJson(json['status']),
        disabledReason: json['disabled_reason'],
        lhsAttribute: json['lhs_attribute'],
        lhsExchange: json['lhs_exchange'],
        lhsTradingsymbol: json['lhs_tradingsymbol'],
        operator: AlertOperator.fromJson(json['operator']),
        rhsType: json['rhs_type'],
        rhsAttribute: json['rhs_attribute'],
        rhsExchange: json['rhs_exchange'],
        rhsTradingsymbol: json['rhs_tradingsymbol'],
        rhsConstant: json['rhs_constant'] != null
            ? (json['rhs_constant'] as num).toDouble()
            : null,
        alertCount: json['alert_count'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
        basket: json['basket'] != null ? Basket.fromJson(json['basket']) : null,
      );

  Map<String, dynamic> toJson() => {
        'type': type.toJson(),
        'user_id': userId,
        'uuid': uuid,
        'name': name,
        'status': status.toJson(),
        'disabled_reason': disabledReason,
        'lhs_attribute': lhsAttribute,
        'lhs_exchange': lhsExchange,
        'lhs_tradingsymbol': lhsTradingsymbol,
        'operator': operator.toJson(),
        'rhs_type': rhsType,
        'rhs_attribute': rhsAttribute,
        'rhs_exchange': rhsExchange,
        'rhs_tradingsymbol': rhsTradingsymbol,
        if (rhsConstant != null) 'rhs_constant': rhsConstant,
        if (alertCount != null) 'alert_count': alertCount,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
        if (basket != null) 'basket': basket!.toJson(),
      };
}

class AlertParams {
  final String name;
  final AlertType type;
  final String lhsExchange;
  final String lhsTradingsymbol;
  final String lhsAttribute;
  final AlertOperator operator;
  final String rhsType;
  final double? rhsConstant;
  final String? rhsExchange;
  final String? rhsTradingsymbol;
  final String? rhsAttribute;
  final Basket? basket;

  AlertParams({
    required this.name,
    required this.type,
    required this.lhsExchange,
    required this.lhsTradingsymbol,
    required this.lhsAttribute,
    required this.operator,
    required this.rhsType,
    this.rhsConstant,
    this.rhsExchange,
    this.rhsTradingsymbol,
    this.rhsAttribute,
    this.basket,
  });

  factory AlertParams.fromJson(Map<String, dynamic> json) => AlertParams(
        name: json['name'],
        type: AlertType.fromJson(json['type']),
        lhsExchange: json['lhs_exchange'],
        lhsTradingsymbol: json['lhs_tradingsymbol'],
        lhsAttribute: json['lhs_attribute'],
        operator: AlertOperator.fromJson(json['operator']),
        rhsType: json['rhs_type'],
        rhsConstant: json['rhs_constant'] != null
            ? (json['rhs_constant'] as num).toDouble()
            : null,
        rhsExchange: json['rhs_exchange'],
        rhsTradingsymbol: json['rhs_tradingsymbol'],
        rhsAttribute: json['rhs_attribute'],
        basket: json['basket'] != null ? Basket.fromJson(json['basket']) : null,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.toJson(),
        'lhs_exchange': lhsExchange,
        'lhs_tradingsymbol': lhsTradingsymbol,
        'lhs_attribute': lhsAttribute,
        'operator': operator.toJson(),
        'rhs_type': rhsType,
        if (rhsConstant != null) 'rhs_constant': rhsConstant,
        if (rhsExchange != null) 'rhs_exchange': rhsExchange,
        if (rhsTradingsymbol != null) 'rhs_tradingsymbol': rhsTradingsymbol,
        if (rhsAttribute != null) 'rhs_attribute': rhsAttribute,
        if (basket != null) 'basket': basket!.toJson(),
      };

  Map<String, String> toFormFields() =>
      toJson().map((key, value) => MapEntry(key, value.toString()));
}

class Basket {
  final String name;
  final String type;
  final List<String> tags;
  final List<BasketItem> items;

  Basket({
    this.name = '',
    this.type = '',
    this.tags = const [],
    required this.items,
  });

  factory Basket.fromJson(Map<String, dynamic> json) => Basket(
        name: json['name'] ?? '',
        type: json['type'] ?? '',
        tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
        items: (json['items'] as List)
            .map((e) => BasketItem.fromJson(e))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type,
        'tags': tags,
        'items': items.map((e) => e.toJson()).toList(),
      };
}

class BasketItem {
  final String type;
  final String tradingsymbol;
  final String exchange;
  final int weight;
  final AlertOrderParams params;
  final int? id;
  final int? instrumentToken;

  BasketItem({
    this.type = '',
    required this.tradingsymbol,
    required this.exchange,
    required this.weight,
    required this.params,
    this.id,
    this.instrumentToken,
  });

  factory BasketItem.fromJson(Map<String, dynamic> json) => BasketItem(
        type: json['type'] ?? '',
        tradingsymbol: json['tradingsymbol'],
        exchange: json['exchange'],
        weight: json['weight'],
        params: AlertOrderParams.fromJson(json['params']),
        id: json['id'],
        instrumentToken: json['instrument_token'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'tradingsymbol': tradingsymbol,
        'exchange': exchange,
        'weight': weight,
        'params': params.toJson(),
        if (id != null) 'id': id,
        if (instrumentToken != null) 'instrument_token': instrumentToken,
      };
}

class AlertOrderParams {
  final String transactionType;
  final String product;
  final String orderType;
  final String validity;
  final int? validityTtl;
  final int quantity;
  final double price;
  final double triggerPrice;
  final int? disclosedQuantity;
  final double? lastPrice;
  final String variety;
  final List<String> tags;
  final double? squareoff;
  final double? stoploss;
  final double? trailingStoploss;
  final int? icebergLegs;
  final double? marketProtection;
  final OrderGTTParams? gtt;

  AlertOrderParams({
    required this.transactionType,
    required this.product,
    required this.orderType,
    required this.validity,
    this.validityTtl,
    required this.quantity,
    required this.price,
    required this.triggerPrice,
    this.disclosedQuantity,
    this.lastPrice,
    required this.variety,
    this.tags = const [],
    this.squareoff,
    this.stoploss,
    this.trailingStoploss,
    this.icebergLegs,
    this.marketProtection,
    this.gtt,
  });

  factory AlertOrderParams.fromJson(Map<String, dynamic> json) =>
      AlertOrderParams(
        transactionType: json['transaction_type'],
        product: json['product'],
        orderType: json['order_type'],
        validity: json['validity'],
        validityTtl: json['validity_ttl'],
        quantity: json['quantity'],
        price: (json['price'] as num).toDouble(),
        triggerPrice: (json['trigger_price'] as num).toDouble(),
        disclosedQuantity: json['disclosed_quantity'],
        lastPrice: json['last_price'] != null
            ? (json['last_price'] as num).toDouble()
            : null,
        variety: json['variety'],
        tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
        squareoff: json['squareoff'] != null
            ? (json['squareoff'] as num).toDouble()
            : null,
        stoploss: json['stoploss'] != null
            ? (json['stoploss'] as num).toDouble()
            : null,
        trailingStoploss: json['trailing_stoploss'] != null
            ? (json['trailing_stoploss'] as num).toDouble()
            : null,
        icebergLegs: json['iceberg_legs'],
        marketProtection: json['market_protection'] != null
            ? (json['market_protection'] as num).toDouble()
            : null,
        gtt: json['gtt'] != null ? OrderGTTParams.fromJson(json['gtt']) : null,
      );

  Map<String, dynamic> toJson() => {
        'transaction_type': transactionType,
        'product': product,
        'order_type': orderType,
        'validity': validity,
        if (validityTtl != null) 'validity_ttl': validityTtl,
        'quantity': quantity,
        'price': price,
        'trigger_price': triggerPrice,
        if (disclosedQuantity != null) 'disclosed_quantity': disclosedQuantity,
        if (lastPrice != null) 'last_price': lastPrice,
        'variety': variety,
        'tags': tags,
        if (squareoff != null) 'squareoff': squareoff,
        if (stoploss != null) 'stoploss': stoploss,
        if (trailingStoploss != null) 'trailing_stoploss': trailingStoploss,
        if (icebergLegs != null) 'iceberg_legs': icebergLegs,
        if (marketProtection != null) 'market_protection': marketProtection,
        if (gtt != null) 'gtt': gtt!.toJson(),
      };
}

class OrderGTTParams {
  final double target;
  final double stoploss;

  OrderGTTParams({
    required this.target,
    required this.stoploss,
  });

  factory OrderGTTParams.fromJson(Map<String, dynamic> json) =>
      OrderGTTParams(
        target: (json['target'] as num).toDouble(),
        stoploss: (json['stoploss'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'target': target,
        'stoploss': stoploss,
      };
}

class AlertHistory {
  final String uuid;
  final AlertType type;
  final List<AlertHistoryMeta> meta;
  final String condition;
  final DateTime? createdAt;
  final dynamic orderMeta;

  AlertHistory({
    required this.uuid,
    required this.type,
    required this.meta,
    required this.condition,
    this.createdAt,
    this.orderMeta,
  });

  factory AlertHistory.fromJson(Map<String, dynamic> json) => AlertHistory(
        uuid: json['uuid'],
        type: AlertType.fromJson(json['type']),
        meta: (json['meta'] as List)
            .map((e) => AlertHistoryMeta.fromJson(e))
            .toList(),
        condition: json['condition'],
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        orderMeta: json['order_meta'],
      );

  Map<String, dynamic> toJson() => {
        'uuid': uuid,
        'type': type.toJson(),
        'meta': meta.map((e) => e.toJson()).toList(),
        'condition': condition,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (orderMeta != null) 'order_meta': orderMeta,
      };
}

class AlertHistoryMeta {
  final int instrumentToken;
  final String tradingsymbol;
  final String timestamp;
  final double lastPrice;
  final OHLC ohlc;
  final double netChange;
  final String exchange;
  final String lastTradeTime;
  final int lastQuantity;
  final int buyQuantity;
  final int sellQuantity;
  final int volume;
  final int volumeTick;
  final double averagePrice;
  final int oi;
  final int oiDayHigh;
  final int oiDayLow;
  final double lowerCircuitLimit;
  final double upperCircuitLimit;

  AlertHistoryMeta({
    required this.instrumentToken,
    required this.tradingsymbol,
    required this.timestamp,
    required this.lastPrice,
    required this.ohlc,
    required this.netChange,
    required this.exchange,
    required this.lastTradeTime,
    required this.lastQuantity,
    required this.buyQuantity,
    required this.sellQuantity,
    required this.volume,
    required this.volumeTick,
    required this.averagePrice,
    required this.oi,
    required this.oiDayHigh,
    required this.oiDayLow,
    required this.lowerCircuitLimit,
    required this.upperCircuitLimit,
  });

  factory AlertHistoryMeta.fromJson(Map<String, dynamic> json) =>
      AlertHistoryMeta(
        instrumentToken: json['instrument_token'],
        tradingsymbol: json['tradingsymbol'],
        timestamp: json['timestamp'],
        lastPrice: (json['last_price'] as num).toDouble(),
        ohlc: OHLC.fromJson(json['ohlc']),
        netChange: (json['net_change'] as num).toDouble(),
        exchange: json['exchange'],
        lastTradeTime: json['last_trade_time'],
        lastQuantity: json['last_quantity'],
        buyQuantity: json['buy_quantity'],
        sellQuantity: json['sell_quantity'],
        volume: json['volume'],
        volumeTick: json['volume_tick'],
        averagePrice: (json['average_price'] as num).toDouble(),
        oi: json['oi'],
        oiDayHigh: json['oi_day_high'],
        oiDayLow: json['oi_day_low'],
        lowerCircuitLimit: (json['lower_circuit_limit'] as num).toDouble(),
        upperCircuitLimit: (json['upper_circuit_limit'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'instrument_token': instrumentToken,
        'tradingsymbol': tradingsymbol,
        'timestamp': timestamp,
        'last_price': lastPrice,
        'ohlc': ohlc.toJson(),
        'net_change': netChange,
        'exchange': exchange,
        'last_trade_time': lastTradeTime,
        'last_quantity': lastQuantity,
        'buy_quantity': buyQuantity,
        'sell_quantity': sellQuantity,
        'volume': volume,
        'volume_tick': volumeTick,
        'average_price': averagePrice,
        'oi': oi,
        'oi_day_high': oiDayHigh,
        'oi_day_low': oiDayLow,
        'lower_circuit_limit': lowerCircuitLimit,
        'upper_circuit_limit': upperCircuitLimit,
      };
}
