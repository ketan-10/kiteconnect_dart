class MFHolding {
  final String folio;
  final String fund;
  final String tradingsymbol;
  final double averagePrice;
  final double lastPrice;
  final String lastPriceDate;
  final double pnl;
  final double quantity;
  final double? pledgedQuantity;

  MFHolding({
    required this.folio,
    required this.fund,
    required this.tradingsymbol,
    required this.averagePrice,
    required this.lastPrice,
    required this.lastPriceDate,
    required this.pnl,
    required this.quantity,
    this.pledgedQuantity,
  });

  factory MFHolding.fromJson(Map<String, dynamic> json) => MFHolding(
        folio: json['folio'],
        fund: json['fund'],
        tradingsymbol: json['tradingsymbol'],
        averagePrice: (json['average_price'] as num).toDouble(),
        lastPrice: (json['last_price'] as num).toDouble(),
        lastPriceDate: json['last_price_date'],
        pnl: (json['pnl'] as num).toDouble(),
        quantity: (json['quantity'] as num).toDouble(),
        pledgedQuantity: json['pledged_quantity'] != null
            ? (json['pledged_quantity'] as num).toDouble()
            : null,
      );

  Map<String, dynamic> toJson() => {
        'folio': folio,
        'fund': fund,
        'tradingsymbol': tradingsymbol,
        'average_price': averagePrice,
        'last_price': lastPrice,
        'last_price_date': lastPriceDate,
        'pnl': pnl,
        'quantity': quantity,
        if (pledgedQuantity != null) 'pledged_quantity': pledgedQuantity,
      };
}

class MFTrade {
  final String fund;
  final String tradingsymbol;
  final double averagePrice;
  final String variety;
  final DateTime? exchangeTimestamp;
  final double amount;
  final String folio;
  final double quantity;

  MFTrade({
    required this.fund,
    required this.tradingsymbol,
    required this.averagePrice,
    required this.variety,
    this.exchangeTimestamp,
    required this.amount,
    required this.folio,
    required this.quantity,
  });

  factory MFTrade.fromJson(Map<String, dynamic> json) => MFTrade(
        fund: json['fund'],
        tradingsymbol: json['tradingsymbol'],
        averagePrice: (json['average_price'] as num).toDouble(),
        variety: json['variety'],
        exchangeTimestamp: json['exchange_timestamp'] != null
            ? DateTime.parse(json['exchange_timestamp'])
            : null,
        amount: (json['amount'] as num).toDouble(),
        folio: json['folio'],
        quantity: (json['quantity'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'fund': fund,
        'tradingsymbol': tradingsymbol,
        'average_price': averagePrice,
        'variety': variety,
        if (exchangeTimestamp != null)
          'exchange_timestamp': exchangeTimestamp!.toIso8601String(),
        'amount': amount,
        'folio': folio,
        'quantity': quantity,
      };
}

typedef MFHoldingBreakdown = List<MFTrade>;
typedef MFHoldings = List<MFHolding>;

class MFOrder {
  final String orderId;
  final String? exchangeOrderId;
  final String tradingsymbol;
  final String status;
  final String? statusMessage;
  final String? folio;
  final String fund;
  final DateTime? orderTimestamp;
  final DateTime? exchangeTimestamp;
  final String? settlementId;
  final String transactionType;
  final String variety;
  final String? purchaseType;
  final double quantity;
  final double amount;
  final double lastPrice;
  final String? lastPriceDate;
  final double averagePrice;
  final String placedBy;
  final String? tag;

  MFOrder({
    required this.orderId,
    this.exchangeOrderId,
    required this.tradingsymbol,
    required this.status,
    this.statusMessage,
    this.folio,
    required this.fund,
    this.orderTimestamp,
    this.exchangeTimestamp,
    this.settlementId,
    required this.transactionType,
    required this.variety,
    this.purchaseType,
    required this.quantity,
    required this.amount,
    required this.lastPrice,
    this.lastPriceDate,
    required this.averagePrice,
    required this.placedBy,
    this.tag,
  });

  factory MFOrder.fromJson(Map<String, dynamic> json) => MFOrder(
        orderId: json['order_id'],
        exchangeOrderId: json['exchange_order_id'],
        tradingsymbol: json['tradingsymbol'],
        status: json['status'],
        statusMessage: json['status_message'],
        folio: json['folio'],
        fund: json['fund'],
        orderTimestamp: json['order_timestamp'] != null
            ? DateTime.parse(json['order_timestamp'])
            : null,
        exchangeTimestamp: json['exchange_timestamp'] != null
            ? DateTime.parse(json['exchange_timestamp'])
            : null,
        settlementId: json['settlement_id'],
        transactionType: json['transaction_type'],
        variety: json['variety'],
        purchaseType: json['purchase_type'],
        quantity: (json['quantity'] as num).toDouble(),
        amount: (json['amount'] as num).toDouble(),
        lastPrice: (json['last_price'] as num).toDouble(),
        lastPriceDate: json['last_price_date'],
        averagePrice: (json['average_price'] as num).toDouble(),
        placedBy: json['placed_by'],
        tag: json['tag'],
      );

  Map<String, dynamic> toJson() => {
        'order_id': orderId,
        if (exchangeOrderId != null) 'exchange_order_id': exchangeOrderId,
        'tradingsymbol': tradingsymbol,
        'status': status,
        if (statusMessage != null) 'status_message': statusMessage,
        if (folio != null) 'folio': folio,
        'fund': fund,
        if (orderTimestamp != null)
          'order_timestamp': orderTimestamp!.toIso8601String(),
        if (exchangeTimestamp != null)
          'exchange_timestamp': exchangeTimestamp!.toIso8601String(),
        if (settlementId != null) 'settlement_id': settlementId,
        'transaction_type': transactionType,
        'variety': variety,
        if (purchaseType != null) 'purchase_type': purchaseType,
        'quantity': quantity,
        'amount': amount,
        'last_price': lastPrice,
        if (lastPriceDate != null) 'last_price_date': lastPriceDate,
        'average_price': averagePrice,
        'placed_by': placedBy,
        if (tag != null) 'tag': tag,
      };
}

typedef MFOrders = List<MFOrder>;
typedef MFAllottedISINs = List<String>;
typedef MFSIPStepUp = Map<String, int>;

class MFSIP {
  final String sipId;
  final String tradingsymbol;
  final String fund;
  final String dividendType;
  final String transactionType;
  final String status;
  final String sipType;
  final DateTime? created;
  final String frequency;
  final double instalmentAmount;
  final int instalments;
  final DateTime? lastInstalment;
  final int pendingInstalments;
  final int instalmentDay;
  final int completedInstalments;
  final String nextInstalment;
  final double triggerPrice;
  final MFSIPStepUp stepUp;
  final String? tag;
  final String? sipRegNum;

  MFSIP({
    required this.sipId,
    required this.tradingsymbol,
    required this.fund,
    required this.dividendType,
    required this.transactionType,
    required this.status,
    required this.sipType,
    this.created,
    required this.frequency,
    required this.instalmentAmount,
    required this.instalments,
    this.lastInstalment,
    required this.pendingInstalments,
    required this.instalmentDay,
    required this.completedInstalments,
    required this.nextInstalment,
    required this.triggerPrice,
    required this.stepUp,
    this.tag,
    this.sipRegNum,
  });

  factory MFSIP.fromJson(Map<String, dynamic> json) => MFSIP(
        sipId: json['sip_id'],
        tradingsymbol: json['tradingsymbol'],
        fund: json['fund'],
        dividendType: json['dividend_type'],
        transactionType: json['transaction_type'],
        status: json['status'],
        sipType: json['sip_type'],
        created:
            json['created'] != null ? DateTime.parse(json['created']) : null,
        frequency: json['frequency'],
        instalmentAmount: (json['instalment_amount'] as num).toDouble(),
        instalments: json['instalments'],
        lastInstalment: json['last_instalment'] != null
            ? DateTime.parse(json['last_instalment'])
            : null,
        pendingInstalments: json['pending_instalments'],
        instalmentDay: json['instalment_day'],
        completedInstalments: json['completed_instalments'],
        nextInstalment: json['next_instalment'],
        triggerPrice: (json['trigger_price'] as num).toDouble(),
        stepUp: Map<String, int>.from(json['step_up'] ?? {}),
        tag: json['tag'],
        sipRegNum: json['sip_reg_num'],
      );

  Map<String, dynamic> toJson() => {
        'sip_id': sipId,
        'tradingsymbol': tradingsymbol,
        'fund': fund,
        'dividend_type': dividendType,
        'transaction_type': transactionType,
        'status': status,
        'sip_type': sipType,
        if (created != null) 'created': created!.toIso8601String(),
        'frequency': frequency,
        'instalment_amount': instalmentAmount,
        'instalments': instalments,
        if (lastInstalment != null)
          'last_instalment': lastInstalment!.toIso8601String(),
        'pending_instalments': pendingInstalments,
        'instalment_day': instalmentDay,
        'completed_instalments': completedInstalments,
        'next_instalment': nextInstalment,
        'trigger_price': triggerPrice,
        'step_up': stepUp,
        if (tag != null) 'tag': tag,
        if (sipRegNum != null) 'sip_reg_num': sipRegNum,
      };
}

typedef MFSIPs = List<MFSIP>;

class MFOrderResponse {
  final String orderId;

  MFOrderResponse({required this.orderId});

  factory MFOrderResponse.fromJson(Map<String, dynamic> json) =>
      MFOrderResponse(orderId: json['order_id']);

  Map<String, dynamic> toJson() => {'order_id': orderId};
}

class MFSIPResponse {
  final String? orderId;
  final String sipId;

  MFSIPResponse({
    this.orderId,
    required this.sipId,
  });

  factory MFSIPResponse.fromJson(Map<String, dynamic> json) => MFSIPResponse(
        orderId: json['order_id'],
        sipId: json['sip_id'],
      );

  Map<String, dynamic> toJson() => {
        if (orderId != null) 'order_id': orderId,
        'sip_id': sipId,
      };
}

class MFOrderParams {
  final String? tradingsymbol;
  final String? transactionType;
  final double? quantity;
  final double? amount;
  final String? tag;

  MFOrderParams({
    this.tradingsymbol,
    this.transactionType,
    this.quantity,
    this.amount,
    this.tag,
  });

  factory MFOrderParams.fromJson(Map<String, dynamic> json) => MFOrderParams(
        tradingsymbol: json['tradingsymbol'],
        transactionType: json['transaction_type'],
        quantity: json['quantity'] != null
            ? (json['quantity'] as num).toDouble()
            : null,
        amount:
            json['amount'] != null ? (json['amount'] as num).toDouble() : null,
        tag: json['tag'],
      );

  Map<String, dynamic> toJson() => {
        if (tradingsymbol != null) 'tradingsymbol': tradingsymbol,
        if (transactionType != null) 'transaction_type': transactionType,
        if (quantity != null) 'quantity': quantity,
        if (amount != null) 'amount': amount,
        if (tag != null) 'tag': tag,
      };
}

class MFSIPParams {
  final String? tradingsymbol;
  final double? amount;
  final int? instalments;
  final String? frequency;
  final int? instalmentDay;
  final double? initialAmount;
  final double? triggerPrice;
  final String? stepUp;
  final String? sipType;
  final String? tag;

  MFSIPParams({
    this.tradingsymbol,
    this.amount,
    this.instalments,
    this.frequency,
    this.instalmentDay,
    this.initialAmount,
    this.triggerPrice,
    this.stepUp,
    this.sipType,
    this.tag,
  });

  factory MFSIPParams.fromJson(Map<String, dynamic> json) => MFSIPParams(
        tradingsymbol: json['tradingsymbol'],
        amount:
            json['amount'] != null ? (json['amount'] as num).toDouble() : null,
        instalments: json['instalments'],
        frequency: json['frequency'],
        instalmentDay: json['instalment_day'],
        initialAmount: json['initial_amount'] != null
            ? (json['initial_amount'] as num).toDouble()
            : null,
        triggerPrice: json['trigger_price'] != null
            ? (json['trigger_price'] as num).toDouble()
            : null,
        stepUp: json['step_up'],
        sipType: json['sip_type'],
        tag: json['tag'],
      );

  Map<String, dynamic> toJson() => {
        if (tradingsymbol != null) 'tradingsymbol': tradingsymbol,
        if (amount != null) 'amount': amount,
        if (instalments != null) 'instalments': instalments,
        if (frequency != null) 'frequency': frequency,
        if (instalmentDay != null) 'instalment_day': instalmentDay,
        if (initialAmount != null) 'initial_amount': initialAmount,
        if (triggerPrice != null) 'trigger_price': triggerPrice,
        if (stepUp != null) 'step_up': stepUp,
        if (sipType != null) 'sip_type': sipType,
        if (tag != null) 'tag': tag,
      };
}

class MFSIPModifyParams {
  final double? amount;
  final String? frequency;
  final int? instalmentDay;
  final int? instalments;
  final String? stepUp;
  final String? status;

  MFSIPModifyParams({
    this.amount,
    this.frequency,
    this.instalmentDay,
    this.instalments,
    this.stepUp,
    this.status,
  });

  factory MFSIPModifyParams.fromJson(Map<String, dynamic> json) =>
      MFSIPModifyParams(
        amount:
            json['amount'] != null ? (json['amount'] as num).toDouble() : null,
        frequency: json['frequency'],
        instalmentDay: json['instalment_day'],
        instalments: json['instalments'],
        stepUp: json['step_up'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        if (amount != null) 'amount': amount,
        if (frequency != null) 'frequency': frequency,
        if (instalmentDay != null) 'instalment_day': instalmentDay,
        if (instalments != null) 'instalments': instalments,
        if (stepUp != null) 'step_up': stepUp,
        if (status != null) 'status': status,
      };
}
