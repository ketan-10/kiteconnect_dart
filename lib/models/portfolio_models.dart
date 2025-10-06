class MTFHolding {
  final int quantity;
  final int usedQuantity;
  final double averagePrice;
  final double value;
  final double initialMargin;

  MTFHolding({
    required this.quantity,
    required this.usedQuantity,
    required this.averagePrice,
    required this.value,
    required this.initialMargin,
  });

  factory MTFHolding.fromJson(Map<String, dynamic> json) => MTFHolding(
    quantity: json['quantity'],
    usedQuantity: json['used_quantity'],
    averagePrice: (json['average_price'] as num).toDouble(),
    value: (json['value'] as num).toDouble(),
    initialMargin: (json['initial_margin'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'quantity': quantity,
    'used_quantity': usedQuantity,
    'average_price': averagePrice,
    'value': value,
    'initial_margin': initialMargin,
  };
}

class Holding {
  final String tradingsymbol;
  final String exchange;
  final int instrumentToken;
  final String isin;
  final String product;
  final double price;
  final int usedQuantity;
  final int quantity;
  final int t1Quantity;
  final int realisedQuantity;
  final int authorisedQuantity;
  final DateTime authorisedDate;
  final int openingQuantity;
  final int collateralQuantity;
  final String collateralType;
  final bool discrepancy;
  final double averagePrice;
  final double lastPrice;
  final double closePrice;
  final double pnl;
  final double dayChange;
  final double dayChangePercentage;
  final MTFHolding mtf;

  Holding({
    required this.tradingsymbol,
    required this.exchange,
    required this.instrumentToken,
    required this.isin,
    required this.product,
    required this.price,
    required this.usedQuantity,
    required this.quantity,
    required this.t1Quantity,
    required this.realisedQuantity,
    required this.authorisedQuantity,
    required this.authorisedDate,
    required this.openingQuantity,
    required this.collateralQuantity,
    required this.collateralType,
    required this.discrepancy,
    required this.averagePrice,
    required this.lastPrice,
    required this.closePrice,
    required this.pnl,
    required this.dayChange,
    required this.dayChangePercentage,
    required this.mtf,
  });

  factory Holding.fromJson(Map<String, dynamic> json) => Holding(
    tradingsymbol: json['tradingsymbol'],
    exchange: json['exchange'],
    instrumentToken: json['instrument_token'],
    isin: json['isin'],
    product: json['product'],
    price: (json['price'] as num).toDouble(),
    usedQuantity: json['used_quantity'],
    quantity: json['quantity'],
    t1Quantity: json['t1_quantity'],
    realisedQuantity: json['realised_quantity'],
    authorisedQuantity: json['authorised_quantity'],
    authorisedDate: DateTime.parse(json['authorised_date']),
    openingQuantity: json['opening_quantity'],
    collateralQuantity: json['collateral_quantity'],
    collateralType: json['collateral_type'],
    discrepancy: json['discrepancy'],
    averagePrice: (json['average_price'] as num).toDouble(),
    lastPrice: (json['last_price'] as num).toDouble(),
    closePrice: (json['close_price'] as num).toDouble(),
    pnl: (json['pnl'] as num).toDouble(),
    dayChange: (json['day_change'] as num).toDouble(),
    dayChangePercentage: (json['day_change_percentage'] as num).toDouble(),
    mtf: MTFHolding.fromJson(json['mtf']),
  );

  Map<String, dynamic> toJson() => {
    'tradingsymbol': tradingsymbol,
    'exchange': exchange,
    'instrument_token': instrumentToken,
    'isin': isin,
    'product': product,
    'price': price,
    'used_quantity': usedQuantity,
    'quantity': quantity,
    't1_quantity': t1Quantity,
    'realised_quantity': realisedQuantity,
    'authorised_quantity': authorisedQuantity,
    'authorised_date': authorisedDate.toIso8601String(),
    'opening_quantity': openingQuantity,
    'collateral_quantity': collateralQuantity,
    'collateral_type': collateralType,
    'discrepancy': discrepancy,
    'average_price': averagePrice,
    'last_price': lastPrice,
    'close_price': closePrice,
    'pnl': pnl,
    'day_change': dayChange,
    'day_change_percentage': dayChangePercentage,
    'mtf': mtf.toJson(),
  };
}

typedef Holdings = List<Holding>;

class Position {
  final String tradingsymbol;
  final String exchange;
  final int instrumentToken;
  final String product;
  final int quantity;
  final int overnightQuantity;
  final double multiplier;
  final double averagePrice;
  final double closePrice;
  final double lastPrice;
  final double value;
  final double pnl;
  final double m2m;
  final double unrealised;
  final double realised;
  final int buyQuantity;
  final double buyPrice;
  final double buyValue;
  final double buyM2m;
  final int sellQuantity;
  final double sellPrice;
  final double sellValue;
  final double sellM2m;
  final int dayBuyQuantity;
  final double dayBuyPrice;
  final double dayBuyValue;
  final int daySellQuantity;
  final double daySellPrice;
  final double daySellValue;

  Position({
    required this.tradingsymbol,
    required this.exchange,
    required this.instrumentToken,
    required this.product,
    required this.quantity,
    required this.overnightQuantity,
    required this.multiplier,
    required this.averagePrice,
    required this.closePrice,
    required this.lastPrice,
    required this.value,
    required this.pnl,
    required this.m2m,
    required this.unrealised,
    required this.realised,
    required this.buyQuantity,
    required this.buyPrice,
    required this.buyValue,
    required this.buyM2m,
    required this.sellQuantity,
    required this.sellPrice,
    required this.sellValue,
    required this.sellM2m,
    required this.dayBuyQuantity,
    required this.dayBuyPrice,
    required this.dayBuyValue,
    required this.daySellQuantity,
    required this.daySellPrice,
    required this.daySellValue,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    tradingsymbol: json['tradingsymbol'],
    exchange: json['exchange'],
    instrumentToken: json['instrument_token'],
    product: json['product'],
    quantity: json['quantity'],
    overnightQuantity: json['overnight_quantity'],
    multiplier: (json['multiplier'] as num).toDouble(),
    averagePrice: (json['average_price'] as num).toDouble(),
    closePrice: (json['close_price'] as num).toDouble(),
    lastPrice: (json['last_price'] as num).toDouble(),
    value: (json['value'] as num).toDouble(),
    pnl: (json['pnl'] as num).toDouble(),
    m2m: (json['m2m'] as num).toDouble(),
    unrealised: (json['unrealised'] as num).toDouble(),
    realised: (json['realised'] as num).toDouble(),
    buyQuantity: json['buy_quantity'],
    buyPrice: (json['buy_price'] as num).toDouble(),
    buyValue: (json['buy_value'] as num).toDouble(),
    buyM2m: (json['buy_m2m'] as num).toDouble(),
    sellQuantity: json['sell_quantity'],
    sellPrice: (json['sell_price'] as num).toDouble(),
    sellValue: (json['sell_value'] as num).toDouble(),
    sellM2m: (json['sell_m2m'] as num).toDouble(),
    dayBuyQuantity: json['day_buy_quantity'],
    dayBuyPrice: (json['day_buy_price'] as num).toDouble(),
    dayBuyValue: (json['day_buy_value'] as num).toDouble(),
    daySellQuantity: json['day_sell_quantity'],
    daySellPrice: (json['day_sell_price'] as num).toDouble(),
    daySellValue: (json['day_sell_value'] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'tradingsymbol': tradingsymbol,
    'exchange': exchange,
    'instrument_token': instrumentToken,
    'product': product,
    'quantity': quantity,
    'overnight_quantity': overnightQuantity,
    'multiplier': multiplier,
    'average_price': averagePrice,
    'close_price': closePrice,
    'last_price': lastPrice,
    'value': value,
    'pnl': pnl,
    'm2m': m2m,
    'unrealised': unrealised,
    'realised': realised,
    'buy_quantity': buyQuantity,
    'buy_price': buyPrice,
    'buy_value': buyValue,
    'buy_m2m': buyM2m,
    'sell_quantity': sellQuantity,
    'sell_price': sellPrice,
    'sell_value': sellValue,
    'sell_m2m': sellM2m,
    'day_buy_quantity': dayBuyQuantity,
    'day_buy_price': dayBuyPrice,
    'day_buy_value': dayBuyValue,
    'day_sell_quantity': daySellQuantity,
    'day_sell_price': daySellPrice,
    'day_sell_value': daySellValue,
  };
}

class Positions {
  final List<Position> net;
  final List<Position> day;

  Positions({required this.net, required this.day});

  factory Positions.fromJson(Map<String, dynamic> json) => Positions(
    net: (json['net'] as List).map((e) => Position.fromJson(e)).toList(),
    day: (json['day'] as List).map((e) => Position.fromJson(e)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'net': net.map((e) => e.toJson()).toList(),
    'day': day.map((e) => e.toJson()).toList(),
  };
}

class ConvertPositionParams {
  final String exchange;
  final String tradingsymbol;
  final String oldProduct;
  final String newProduct;
  final String positionType;
  final String transactionType;
  final int quantity;

  ConvertPositionParams({
    required this.exchange,
    required this.tradingsymbol,
    required this.oldProduct,
    required this.newProduct,
    required this.positionType,
    required this.transactionType,
    required this.quantity,
  });

  factory ConvertPositionParams.fromJson(Map<String, dynamic> json) =>
      ConvertPositionParams(
        exchange: json['exchange'],
        tradingsymbol: json['tradingsymbol'],
        oldProduct: json['old_product'],
        newProduct: json['new_product'],
        positionType: json['position_type'],
        transactionType: json['transaction_type'],
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
    'exchange': exchange,
    'tradingsymbol': tradingsymbol,
    'old_product': oldProduct,
    'new_product': newProduct,
    'position_type': positionType,
    'transaction_type': transactionType,
    'quantity': quantity,
  };

  Map<String, String> toFormFields() =>
      toJson().map((key, value) => MapEntry(key, value.toString()));
}

class AuctionInstrument {
  final String tradingsymbol;
  final String exchange;
  final int instrumentToken;
  final String isin;
  final String product;
  final double price;
  final int quantity;
  final int t1Quantity;
  final int realisedQuantity;
  final int authorisedQuantity;
  final String authorisedDate;
  final int openingQuantity;
  final int collateralQuantity;
  final String collateralType;
  final bool discrepancy;
  final double averagePrice;
  final double lastPrice;
  final double closePrice;
  final double pnl;
  final double dayChange;
  final double dayChangePercentage;
  final String auctionNumber;

  AuctionInstrument({
    required this.tradingsymbol,
    required this.exchange,
    required this.instrumentToken,
    required this.isin,
    required this.product,
    required this.price,
    required this.quantity,
    required this.t1Quantity,
    required this.realisedQuantity,
    required this.authorisedQuantity,
    required this.authorisedDate,
    required this.openingQuantity,
    required this.collateralQuantity,
    required this.collateralType,
    required this.discrepancy,
    required this.averagePrice,
    required this.lastPrice,
    required this.closePrice,
    required this.pnl,
    required this.dayChange,
    required this.dayChangePercentage,
    required this.auctionNumber,
  });

  factory AuctionInstrument.fromJson(Map<String, dynamic> json) =>
      AuctionInstrument(
        tradingsymbol: json['tradingsymbol'],
        exchange: json['exchange'],
        instrumentToken: json['instrument_token'],
        isin: json['isin'],
        product: json['product'],
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'],
        t1Quantity: json['t1_quantity'],
        realisedQuantity: json['realised_quantity'],
        authorisedQuantity: json['authorised_quantity'],
        authorisedDate: json['authorised_date'],
        openingQuantity: json['opening_quantity'],
        collateralQuantity: json['collateral_quantity'],
        collateralType: json['collateral_type'],
        discrepancy: json['discrepancy'],
        averagePrice: (json['average_price'] as num).toDouble(),
        lastPrice: (json['last_price'] as num).toDouble(),
        closePrice: (json['close_price'] as num).toDouble(),
        pnl: (json['pnl'] as num).toDouble(),
        dayChange: (json['day_change'] as num).toDouble(),
        dayChangePercentage: (json['day_change_percentage'] as num).toDouble(),
        auctionNumber: json['auction_number'],
      );

  Map<String, dynamic> toJson() => {
    'tradingsymbol': tradingsymbol,
    'exchange': exchange,
    'instrument_token': instrumentToken,
    'isin': isin,
    'product': product,
    'price': price,
    'quantity': quantity,
    't1_quantity': t1Quantity,
    'realised_quantity': realisedQuantity,
    'authorised_quantity': authorisedQuantity,
    'authorised_date': authorisedDate,
    'opening_quantity': openingQuantity,
    'collateral_quantity': collateralQuantity,
    'collateral_type': collateralType,
    'discrepancy': discrepancy,
    'average_price': averagePrice,
    'last_price': lastPrice,
    'close_price': closePrice,
    'pnl': pnl,
    'day_change': dayChange,
    'day_change_percentage': dayChangePercentage,
    'auction_number': auctionNumber,
  };
}

class HoldingsAuthInstruments {
  final String isin;
  final double quantity;

  HoldingsAuthInstruments({required this.isin, required this.quantity});

  factory HoldingsAuthInstruments.fromJson(Map<String, dynamic> json) =>
      HoldingsAuthInstruments(
        isin: json['isin'],
        quantity: (json['quantity'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {'isin': isin, 'quantity': quantity};
}

class HoldingAuthParams {
  final String authType;
  final String transferType;
  final String execDate;
  final List<HoldingsAuthInstruments>? instruments;

  HoldingAuthParams({
    required this.authType,
    required this.transferType,
    required this.execDate,
    this.instruments,
  });

  factory HoldingAuthParams.fromJson(Map<String, dynamic> json) =>
      HoldingAuthParams(
        authType: json['type'],
        transferType: json['transfer_type'],
        execDate: json['exec_date'],
        instruments: json['instruments'] != null
            ? (json['instruments'] as List)
                  .map((e) => HoldingsAuthInstruments.fromJson(e))
                  .toList()
            : null,
      );

  Map<String, dynamic> toJson() => {
    'type': authType,
    'transfer_type': transferType,
    'exec_date': execDate,
    if (instruments != null)
      'instruments': instruments!.map((e) => e.toJson()).toList(),
  };
}

class HoldingsAuthResp {
  final String requestId;
  final String? redirectUrl;

  HoldingsAuthResp({required this.requestId, this.redirectUrl});

  factory HoldingsAuthResp.fromJson(Map<String, dynamic> json) =>
      HoldingsAuthResp(
        requestId: json['request_id'],
        redirectUrl: json['redirect_url'],
      );

  Map<String, dynamic> toJson() => {
    'request_id': requestId,
    if (redirectUrl != null) 'redirect_url': redirectUrl,
  };
}
