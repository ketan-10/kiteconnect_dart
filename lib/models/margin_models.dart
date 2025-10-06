class OrderMarginParam {
  final String exchange;
  final String tradingSymbol;
  final String transactionType;
  final String variety;
  final String product;
  final String orderType;
  final double quantity;
  final double? price;
  final double? triggerPrice;

  OrderMarginParam({
    required this.exchange,
    required this.tradingSymbol,
    required this.transactionType,
    required this.variety,
    required this.product,
    required this.orderType,
    required this.quantity,
    this.price,
    this.triggerPrice,
  });

  factory OrderMarginParam.fromJson(Map<String, dynamic> json) =>
      OrderMarginParam(
        exchange: json['exchange'],
        tradingSymbol: json['tradingsymbol'],
        transactionType: json['transaction_type'],
        variety: json['variety'],
        product: json['product'],
        orderType: json['order_type'],
        quantity: (json['quantity'] as num).toDouble(),
        price: json['price'] != null ? (json['price'] as num).toDouble() : null,
        triggerPrice: json['trigger_price'] != null
            ? (json['trigger_price'] as num).toDouble()
            : null,
      );

  Map<String, dynamic> toJson() => {
    'exchange': exchange,
    'tradingsymbol': tradingSymbol,
    'transaction_type': transactionType,
    'variety': variety,
    'product': product,
    'order_type': orderType,
    'quantity': quantity,
    if (price != null) 'price': price,
    if (triggerPrice != null) 'trigger_price': triggerPrice,
  };
}

class OrderChargesParam {
  final String orderId;
  final String exchange;
  final String tradingSymbol;
  final String transactionType;
  final String variety;
  final String product;
  final String orderType;
  final double quantity;
  final double averagePrice;

  OrderChargesParam({
    required this.orderId,
    required this.exchange,
    required this.tradingSymbol,
    required this.transactionType,
    required this.variety,
    required this.product,
    required this.orderType,
    required this.quantity,
    required this.averagePrice,
  });

  factory OrderChargesParam.fromJson(Map<String, dynamic> json) =>
      OrderChargesParam(
        orderId: json['order_id'],
        exchange: json['exchange'],
        tradingSymbol: json['tradingsymbol'],
        transactionType: json['transaction_type'],
        variety: json['variety'],
        product: json['product'],
        orderType: json['order_type'],
        quantity: (json['quantity'] as num).toDouble(),
        averagePrice: (json['average_price'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'exchange': exchange,
    'tradingsymbol': tradingSymbol,
    'transaction_type': transactionType,
    'variety': variety,
    'product': product,
    'order_type': orderType,
    'quantity': quantity,
    'average_price': averagePrice,
  };
}

class PNL {
  final double realised;
  final double unrealised;

  PNL({required this.realised, required this.unrealised});

  factory PNL.fromJson(Map<String, dynamic> json) => PNL(
    realised: (json['realised'] as num).toDouble(),
    unrealised: (json['unrealised'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'realised': realised,
    'unrealised': unrealised,
  };
}

class GST {
  final double igst;
  final double cgst;
  final double sgst;
  final double total;

  GST({
    required this.igst,
    required this.cgst,
    required this.sgst,
    required this.total,
  });

  factory GST.fromJson(Map<String, dynamic> json) => GST(
    igst: (json['igst'] as num).toDouble(),
    cgst: (json['cgst'] as num).toDouble(),
    sgst: (json['sgst'] as num).toDouble(),
    total: (json['total'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'igst': igst,
    'cgst': cgst,
    'sgst': sgst,
    'total': total,
  };
}

class Charges {
  final double transactionTax;
  final String transactionTaxType;
  final double exchangeTurnoverCharge;
  final double sebiTurnoverCharge;
  final double brokerage;
  final double stampDuty;
  final GST gst;
  final double total;

  Charges({
    required this.transactionTax,
    required this.transactionTaxType,
    required this.exchangeTurnoverCharge,
    required this.sebiTurnoverCharge,
    required this.brokerage,
    required this.stampDuty,
    required this.gst,
    required this.total,
  });

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
    transactionTax: (json['transaction_tax'] as num).toDouble(),
    transactionTaxType: json['transaction_tax_type'],
    exchangeTurnoverCharge: (json['exchange_turnover_charge'] as num)
        .toDouble(),
    sebiTurnoverCharge: (json['sebi_turnover_charge'] as num).toDouble(),
    brokerage: (json['brokerage'] as num).toDouble(),
    stampDuty: (json['stamp_duty'] as num).toDouble(),
    gst: GST.fromJson(json['gst']),
    total: (json['total'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'transaction_tax': transactionTax,
    'transaction_tax_type': transactionTaxType,
    'exchange_turnover_charge': exchangeTurnoverCharge,
    'sebi_turnover_charge': sebiTurnoverCharge,
    'brokerage': brokerage,
    'stamp_duty': stampDuty,
    'gst': gst.toJson(),
    'total': total,
  };
}

class OrderMargins {
  final String orderType;
  final String tradingSymbol;
  final String exchange;
  final double span;
  final double exposure;
  final double optionPremium;
  final double additional;
  final double bo;
  final double cash;
  final double var_;
  final PNL? pnl;
  final double leverage;
  final Charges charges;
  final double total;

  OrderMargins({
    required this.orderType,
    required this.tradingSymbol,
    required this.exchange,
    this.span = 0.0,
    this.exposure = 0.0,
    this.optionPremium = 0.0,
    this.additional = 0.0,
    this.bo = 0.0,
    this.cash = 0.0,
    this.var_ = 0.0,
    this.pnl,
    this.leverage = 0.0,
    required this.charges,
    required this.total,
  });

  factory OrderMargins.fromJson(Map<String, dynamic> json) => OrderMargins(
    orderType: json['type'],
    tradingSymbol: json['tradingsymbol'],
    exchange: json['exchange'],
    span: json['span'] != null ? (json['span'] as num).toDouble() : 0.0,
    exposure: json['exposure'] != null
        ? (json['exposure'] as num).toDouble()
        : 0.0,
    optionPremium: json['option_premium'] != null
        ? (json['option_premium'] as num).toDouble()
        : 0.0,
    additional: json['additional'] != null
        ? (json['additional'] as num).toDouble()
        : 0.0,
    bo: json['bo'] != null ? (json['bo'] as num).toDouble() : 0.0,
    cash: json['cash'] != null ? (json['cash'] as num).toDouble() : 0.0,
    var_: json['var'] != null ? (json['var'] as num).toDouble() : 0.0,
    pnl: json['pnl'] != null ? PNL.fromJson(json['pnl']) : null,
    leverage: json['leverage'] != null
        ? (json['leverage'] as num).toDouble()
        : 0.0,
    charges: Charges.fromJson(json['charges']),
    total: (json['total'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'type': orderType,
    'tradingsymbol': tradingSymbol,
    'exchange': exchange,
    'span': span,
    'exposure': exposure,
    'option_premium': optionPremium,
    'additional': additional,
    'bo': bo,
    'cash': cash,
    'var': var_,
    if (pnl != null) 'pnl': pnl!.toJson(),
    'leverage': leverage,
    'charges': charges.toJson(),
    'total': total,
  };
}

class OrderCharges {
  final String exchange;
  final String tradingSymbol;
  final String transactionType;
  final String variety;
  final String product;
  final String orderType;
  final double quantity;
  final double price;
  final Charges charges;

  OrderCharges({
    required this.exchange,
    required this.tradingSymbol,
    required this.transactionType,
    required this.variety,
    required this.product,
    required this.orderType,
    required this.quantity,
    required this.price,
    required this.charges,
  });

  factory OrderCharges.fromJson(Map<String, dynamic> json) => OrderCharges(
    exchange: json['exchange'],
    tradingSymbol: json['tradingsymbol'],
    transactionType: json['transaction_type'],
    variety: json['variety'],
    product: json['product'],
    orderType: json['order_type'],
    quantity: (json['quantity'] as num).toDouble(),
    price: (json['price'] as num).toDouble(),
    charges: Charges.fromJson(json['charges']),
  );

  Map<String, dynamic> toJson() => {
    'exchange': exchange,
    'tradingsymbol': tradingSymbol,
    'transaction_type': transactionType,
    'variety': variety,
    'product': product,
    'order_type': orderType,
    'quantity': quantity,
    'price': price,
    'charges': charges.toJson(),
  };
}

class BasketMargins {
  final OrderMargins? initial;
  final OrderMargins? finalMargins;
  final List<OrderMargins> orders;

  BasketMargins({this.initial, this.finalMargins, required this.orders});

  factory BasketMargins.fromJson(Map<String, dynamic> json) => BasketMargins(
    initial: json['initial'] != null
        ? OrderMargins.fromJson(json['initial'])
        : null,
    finalMargins: json['final'] != null
        ? OrderMargins.fromJson(json['final'])
        : null,
    orders: (json['orders'] as List)
        .map((e) => OrderMargins.fromJson(e))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    if (initial != null) 'initial': initial!.toJson(),
    if (finalMargins != null) 'final': finalMargins!.toJson(),
    'orders': orders.map((e) => e.toJson()).toList(),
  };
}

class GetMarginParams {
  final List<OrderMarginParam> orderParams;
  final bool compact;

  GetMarginParams({required this.orderParams, this.compact = false});
}

class GetBasketParams {
  final List<OrderMarginParam> orderParams;
  final bool compact;
  final bool considerPositions;

  GetBasketParams({
    required this.orderParams,
    this.compact = false,
    this.considerPositions = false,
  });
}

class GetChargesParams {
  final List<OrderChargesParam> orderParams;

  GetChargesParams({required this.orderParams});
}
