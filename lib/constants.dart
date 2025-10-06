class AppConstants {
  static const String defaultBaseUrl = 'https://api.kite.trade';
  static const String kiteBaseUrl = 'https://kite.zerodha.com';
  static const Duration defaultTimeout = Duration(seconds: 7);
  static const String kiteHeaderVersion = '3';
  static const String kiteConnectName = 'kiteconnect_dart';
  static const String kiteConnectVersion = '0.1.0';
}

class Endpoints {
  static const String loginUrl = '/connect/login';
  static const String sessionGenerate = '/session/token';
  static const String invalidateToken = '/session/token';
  static const String renewAccess = '/session/refresh_token';
  static const String userProfile = '/user/profile';
  static const String userFullProfile = '/user/profile/full';
  static const String userMargins = '/user/margins';
  static const String userMarginsSegment = '/user/margins/{segment}';

  // Portfolio endpoints
  static const String getHoldings = '/portfolio/holdings';
  static const String getPositions = '/portfolio/positions';
  static const String convertPosition = '/portfolio/positions';
  static const String auctionInstruments = '/portfolio/holdings/auctions';
  static const String initHoldingsAuth = '/portfolio/holdings/authorise';

  // Order endpoints
  static const String getOrders = '/orders';
  static const String getTrades = '/trades';
  static const String getOrderHistory = '/orders/{order_id}';
  static const String getOrderTrades = '/orders/{order_id}/trades';
  static const String placeOrder = '/orders/{variety}';
  static const String modifyOrder = '/orders/{variety}/{order_id}';
  static const String cancelOrder = '/orders/{variety}/{order_id}';

  // Mutual Fund endpoints
  static const String getMfOrders = '/mf/orders';
  static const String getMfOrderInfo = '/mf/orders/{order_id}';
  static const String placeMfOrder = '/mf/orders';
  static const String cancelMfOrder = '/mf/orders/{order_id}';
  static const String getMfSips = '/mf/sips';
  static const String getMfSipInfo = '/mf/sips/{sip_id}';
  static const String placeMfSip = '/mf/sips';
  static const String modifyMfSip = '/mf/sips/{sip_id}';
  static const String cancelMfSip = '/mf/sips/{sip_id}';
  static const String getMfHoldings = '/mf/holdings';
  static const String getMfHoldingInfo = '/mf/holdings/{isin}';
  static const String getMfAllottedIsins = '/mf/allotments';

  // Margin endpoints
  static const String orderMargins = '/margins/orders';
  static const String basketMargins = '/margins/basket';
  static const String orderCharges = '/charges/orders';

  // Market data endpoints
  static const String getQuote = '/quote';
  static const String getLtp = '/quote/ltp';
  static const String getOhlc = '/quote/ohlc';
  static const String getInstruments = '/instruments';
  static const String getMfInstruments = '/mf/instruments';
  static const String getInstrumentsExchange = '/instruments/{exchange}';
  static const String getHistorical = '/instruments/historical/{instrument_token}/{interval}';

  // Alerts endpoints
  static const String alertsUrl = '/alerts';
  static const String alertUrl = '/alerts/{alert_id}';
  static const String getAlertHistory = '/alerts/{alert_id}/history';
}

class Labels {
  // Order varieties
  static const String varietyRegular = 'regular';
  static const String varietyAmo = 'amo';
  static const String varietyIceberg = 'iceberg';
  static const String varietyBracket = 'bo';
  static const String varietyCover = 'co';
  static const String varietyAuction = 'auction';

  // Order types
  static const String orderTypeMarket = 'MARKET';
  static const String orderTypeLimit = 'LIMIT';
  static const String orderTypeSl = 'SL';
  static const String orderTypeSlM = 'SL-M';

  // Transaction types
  static const String transactionTypeBuy = 'BUY';
  static const String transactionTypeSell = 'SELL';

  // Products
  static const String productCnc = 'CNC';
  static const String productNrml = 'NRML';
  static const String productMis = 'MIS';
  static const String productBo = 'BO';
  static const String productCo = 'CO';

  // Validity
  static const String validityDay = 'DAY';
  static const String validityIoc = 'IOC';
  static const String validityTtl = 'TTL';

  // Exchanges
  static const String exchangeNse = 'NSE';
  static const String exchangeBse = 'BSE';
  static const String exchangeNfo = 'NFO';
  static const String exchangeBfo = 'BFO';
  static const String exchangeMcx = 'MCX';
  static const String exchangeCds = 'CDS';
  static const String exchangeBcd = 'BCD';

  // Position types
  static const String positionTypeDay = 'day';
  static const String positionTypeOvernight = 'overnight';

  // Intervals
  static const String intervalMinute = 'minute';
  static const String interval3Minute = '3minute';
  static const String interval5Minute = '5minute';
  static const String interval10Minute = '10minute';
  static const String interval15Minute = '15minute';
  static const String interval30Minute = '30minute';
  static const String interval60Minute = '60minute';
  static const String intervalDay = 'day';
}