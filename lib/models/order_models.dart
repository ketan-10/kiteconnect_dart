class Order {
  final String? accountId;
  final String placedBy;
  final String orderId;
  final String? exchangeOrderId;
  final String? parentOrderId;
  final String status;
  final String? statusMessage;
  final String? statusMessageRaw;
  final DateTime? orderTimestamp;
  final DateTime? exchangeUpdateTimestamp;
  final DateTime? exchangeTimestamp;
  final String variety;
  final bool modified;
  final Map<String, dynamic> meta;
  final String exchange;
  final String tradingsymbol;
  final int instrumentToken;
  final String orderType;
  final String transactionType;
  final String validity;
  final int? validityTtl;
  final String product;
  final double quantity;
  final double disclosedQuantity;
  final double price;
  final double triggerPrice;
  final double averagePrice;
  final double filledQuantity;
  final double pendingQuantity;
  final double cancelledQuantity;
  final String? auctionNumber;
  final String? tag;
  final List<String>? tags;
  final double? marketProtection;
  final String? guid;

  Order({
    this.accountId,
    required this.placedBy,
    required this.orderId,
    this.exchangeOrderId,
    this.parentOrderId,
    required this.status,
    this.statusMessage,
    this.statusMessageRaw,
    this.orderTimestamp,
    this.exchangeUpdateTimestamp,
    this.exchangeTimestamp,
    required this.variety,
    this.modified = false,
    this.meta = const {},
    required this.exchange,
    required this.tradingsymbol,
    required this.instrumentToken,
    required this.orderType,
    required this.transactionType,
    required this.validity,
    this.validityTtl,
    required this.product,
    required this.quantity,
    required this.disclosedQuantity,
    required this.price,
    required this.triggerPrice,
    required this.averagePrice,
    required this.filledQuantity,
    required this.pendingQuantity,
    required this.cancelledQuantity,
    this.auctionNumber,
    this.tag,
    this.tags,
    this.marketProtection,
    this.guid,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        accountId: json['account_id'],
        placedBy: json['placed_by'],
        orderId: json['order_id'],
        exchangeOrderId: json['exchange_order_id'],
        parentOrderId: json['parent_order_id'],
        status: json['status'],
        statusMessage: json['status_message'],
        statusMessageRaw: json['status_message_raw'],
        orderTimestamp: json['order_timestamp'] != null
            ? DateTime.parse(json['order_timestamp'])
            : null,
        exchangeUpdateTimestamp: json['exchange_update_timestamp'] != null
            ? DateTime.parse(json['exchange_update_timestamp'])
            : null,
        exchangeTimestamp: json['exchange_timestamp'] != null
            ? DateTime.parse(json['exchange_timestamp'])
            : null,
        variety: json['variety'],
        modified: json['modified'] ?? false,
        meta: json['meta'] != null
            ? Map<String, dynamic>.from(json['meta'])
            : {},
        exchange: json['exchange'],
        tradingsymbol: json['tradingsymbol'],
        instrumentToken: json['instrument_token'],
        orderType: json['order_type'],
        transactionType: json['transaction_type'],
        validity: json['validity'],
        validityTtl: json['validity_ttl'],
        product: json['product'],
        quantity: (json['quantity'] as num).toDouble(),
        disclosedQuantity: (json['disclosed_quantity'] as num).toDouble(),
        price: (json['price'] as num).toDouble(),
        triggerPrice: (json['trigger_price'] as num).toDouble(),
        averagePrice: (json['average_price'] as num).toDouble(),
        filledQuantity: (json['filled_quantity'] as num).toDouble(),
        pendingQuantity: (json['pending_quantity'] as num).toDouble(),
        cancelledQuantity: (json['cancelled_quantity'] as num).toDouble(),
        auctionNumber: json['auction_number'],
        tag: json['tag'],
        tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
        marketProtection: json['market_protection'] != null
            ? (json['market_protection'] as num).toDouble()
            : null,
        guid: json['guid'],
      );

  Map<String, dynamic> toJson() => {
        if (accountId != null) 'account_id': accountId,
        'placed_by': placedBy,
        'order_id': orderId,
        if (exchangeOrderId != null) 'exchange_order_id': exchangeOrderId,
        if (parentOrderId != null) 'parent_order_id': parentOrderId,
        'status': status,
        if (statusMessage != null) 'status_message': statusMessage,
        if (statusMessageRaw != null) 'status_message_raw': statusMessageRaw,
        if (orderTimestamp != null)
          'order_timestamp': orderTimestamp!.toIso8601String(),
        if (exchangeUpdateTimestamp != null)
          'exchange_update_timestamp':
              exchangeUpdateTimestamp!.toIso8601String(),
        if (exchangeTimestamp != null)
          'exchange_timestamp': exchangeTimestamp!.toIso8601String(),
        'variety': variety,
        'modified': modified,
        'meta': meta,
        'exchange': exchange,
        'tradingsymbol': tradingsymbol,
        'instrument_token': instrumentToken,
        'order_type': orderType,
        'transaction_type': transactionType,
        'validity': validity,
        if (validityTtl != null) 'validity_ttl': validityTtl,
        'product': product,
        'quantity': quantity,
        'disclosed_quantity': disclosedQuantity,
        'price': price,
        'trigger_price': triggerPrice,
        'average_price': averagePrice,
        'filled_quantity': filledQuantity,
        'pending_quantity': pendingQuantity,
        'cancelled_quantity': cancelledQuantity,
        if (auctionNumber != null) 'auction_number': auctionNumber,
        if (tag != null) 'tag': tag,
        if (tags != null) 'tags': tags,
        if (marketProtection != null) 'market_protection': marketProtection,
        if (guid != null) 'guid': guid,
      };
}

typedef Orders = List<Order>;

class OrderParams {
  final String? exchange;
  final String? tradingsymbol;
  final String? validity;
  final int? validityTtl;
  final String? product;
  final String? orderType;
  final String? transactionType;
  final int? quantity;
  final int? disclosedQuantity;
  final double? price;
  final double? triggerPrice;
  final double? squareoff;
  final double? stoploss;
  final double? trailingStoploss;
  final int? icebergLegs;
  final int? icebergQuantity;
  final String? auctionNumber;
  final String? tag;

  OrderParams({
    this.exchange,
    this.tradingsymbol,
    this.validity,
    this.validityTtl,
    this.product,
    this.orderType,
    this.transactionType,
    this.quantity,
    this.disclosedQuantity,
    this.price,
    this.triggerPrice,
    this.squareoff,
    this.stoploss,
    this.trailingStoploss,
    this.icebergLegs,
    this.icebergQuantity,
    this.auctionNumber,
    this.tag,
  });

  factory OrderParams.fromJson(Map<String, dynamic> json) => OrderParams(
        exchange: json['exchange'],
        tradingsymbol: json['tradingsymbol'],
        validity: json['validity'],
        validityTtl: json['validity_ttl'],
        product: json['product'],
        orderType: json['order_type'],
        transactionType: json['transaction_type'],
        quantity: json['quantity'],
        disclosedQuantity: json['disclosed_quantity'],
        price: json['price'] != null
            ? (json['price'] as num).toDouble()
            : null,
        triggerPrice: json['trigger_price'] != null
            ? (json['trigger_price'] as num).toDouble()
            : null,
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
        icebergQuantity: json['iceberg_quantity'],
        auctionNumber: json['auction_number'],
        tag: json['tag'],
      );

  Map<String, dynamic> toJson() => {
        if (exchange != null) 'exchange': exchange,
        if (tradingsymbol != null) 'tradingsymbol': tradingsymbol,
        if (validity != null) 'validity': validity,
        if (validityTtl != null) 'validity_ttl': validityTtl,
        if (product != null) 'product': product,
        if (orderType != null) 'order_type': orderType,
        if (transactionType != null) 'transaction_type': transactionType,
        if (quantity != null) 'quantity': quantity,
        if (disclosedQuantity != null) 'disclosed_quantity': disclosedQuantity,
        if (price != null) 'price': price,
        if (triggerPrice != null) 'trigger_price': triggerPrice,
        if (squareoff != null) 'squareoff': squareoff,
        if (stoploss != null) 'stoploss': stoploss,
        if (trailingStoploss != null) 'trailing_stoploss': trailingStoploss,
        if (icebergLegs != null) 'iceberg_legs': icebergLegs,
        if (icebergQuantity != null) 'iceberg_quantity': icebergQuantity,
        if (auctionNumber != null) 'auction_number': auctionNumber,
        if (tag != null) 'tag': tag,
      };

  Map<String, String> toFormFields() =>
      toJson().map((key, value) => MapEntry(key, value.toString()));
}

class OrderResponse {
  final String orderId;

  OrderResponse({required this.orderId});

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      OrderResponse(orderId: json['order_id']);

  Map<String, dynamic> toJson() => {'order_id': orderId};
}

class Trade {
  final double averagePrice;
  final double quantity;
  final String tradeId;
  final String product;
  final DateTime? fillTimestamp;
  final DateTime? exchangeTimestamp;
  final String exchangeOrderId;
  final String orderId;
  final String transactionType;
  final String tradingsymbol;
  final String exchange;
  final int instrumentToken;
  final String? orderTimestamp;

  Trade({
    required this.averagePrice,
    required this.quantity,
    required this.tradeId,
    required this.product,
    this.fillTimestamp,
    this.exchangeTimestamp,
    required this.exchangeOrderId,
    required this.orderId,
    required this.transactionType,
    required this.tradingsymbol,
    required this.exchange,
    required this.instrumentToken,
    this.orderTimestamp,
  });

  factory Trade.fromJson(Map<String, dynamic> json) => Trade(
        averagePrice: (json['average_price'] as num).toDouble(),
        quantity: (json['quantity'] as num).toDouble(),
        tradeId: json['trade_id'],
        product: json['product'],
        fillTimestamp: json['fill_timestamp'] != null
            ? DateTime.parse(json['fill_timestamp'])
            : null,
        exchangeTimestamp: json['exchange_timestamp'] != null
            ? DateTime.parse(json['exchange_timestamp'])
            : null,
        exchangeOrderId: json['exchange_order_id'],
        orderId: json['order_id'],
        transactionType: json['transaction_type'],
        tradingsymbol: json['tradingsymbol'],
        exchange: json['exchange'],
        instrumentToken: json['instrument_token'],
        orderTimestamp: json['order_timestamp'],
      );

  Map<String, dynamic> toJson() => {
        'average_price': averagePrice,
        'quantity': quantity,
        'trade_id': tradeId,
        'product': product,
        if (fillTimestamp != null)
          'fill_timestamp': fillTimestamp!.toIso8601String(),
        if (exchangeTimestamp != null)
          'exchange_timestamp': exchangeTimestamp!.toIso8601String(),
        'exchange_order_id': exchangeOrderId,
        'order_id': orderId,
        'transaction_type': transactionType,
        'tradingsymbol': tradingsymbol,
        'exchange': exchange,
        'instrument_token': instrumentToken,
        if (orderTimestamp != null) 'order_timestamp': orderTimestamp,
      };
}

typedef Trades = List<Trade>;
