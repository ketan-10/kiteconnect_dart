import 'package:kiteconnect_dart/constants.dart';
import 'package:kiteconnect_dart/models/market_models.dart';
import 'package:kiteconnect_dart/kite_connect.dart';

/// Mixin providing market data methods
mixin MarketMethods on KiteConnectBase {
  /// Gets full quote for multiple instruments
  Future<Quote> getQuote(List<String> instruments) async {
    final queryParams = instruments.map((i) => 'i=$i').join('&');
    final endpoint = '${Endpoints.getQuote}?$queryParams';

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    final data = unwrapResponse(response) as Map<String, dynamic>;
    return data.map((key, value) => MapEntry(key, QuoteData.fromJson(value)));
  }

  /// Gets last traded price for multiple instruments
  Future<QuoteLTP> getLTP(List<String> instruments) async {
    final queryParams = instruments.map((i) => 'i=$i').join('&');
    final endpoint = '${Endpoints.getLtp}?$queryParams';

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    final data = unwrapResponse(response) as Map<String, dynamic>;
    return data.map((key, value) => MapEntry(key, QuoteLTPData.fromJson(value)));
  }

  /// Gets OHLC for multiple instruments
  Future<QuoteOHLC> getOHLC(List<String> instruments) async {
    final queryParams = instruments.map((i) => 'i=$i').join('&');
    final endpoint = '${Endpoints.getOhlc}?$queryParams';

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    final data = unwrapResponse(response) as Map<String, dynamic>;
    return data.map((key, value) => MapEntry(key, QuoteOHLCData.fromJson(value)));
  }

  /// Gets historical candle data for an instrument
  Future<List<HistoricalData>> getHistoricalData(
    int instrumentToken,
    String interval,
    String fromDate,
    String toDate, {
    bool continuous = false,
    bool oi = false,
  }) async {
    final endpoint = Endpoints.getHistorical
        .replaceAll('{instrument_token}', instrumentToken.toString())
        .replaceAll('{interval}', interval);

    final queryParams = <String>[];
    queryParams.add('from=$fromDate');
    queryParams.add('to=$toDate');
    if (continuous) queryParams.add('continuous=1');
    if (oi) queryParams.add('oi=1');

    final fullEndpoint = '$endpoint?${queryParams.join('&')}';

    final response = await performRequest(
      RequestMethod.get,
      fullEndpoint,
    );

    final data = unwrapResponse(response);
    return (data['candles'] as List).map((candle) {
      final c = candle as List;
      return HistoricalData(
        date: c[0] != null ? DateTime.parse(c[0]) : null,
        open: (c[1] as num).toDouble(),
        high: (c[2] as num).toDouble(),
        low: (c[3] as num).toDouble(),
        close: (c[4] as num).toDouble(),
        volume: c[5] as int,
        oi: c.length > 6 ? c[6] as int : 0,
      );
    }).toList();
  }

  /// Gets all instruments across exchanges
  Future<Instruments> getInstruments() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.getInstruments,
    );

    return parseInstrumentsCSV(response);
  }

  /// Gets instruments for a specific exchange
  Future<Instruments> getInstrumentsByExchange(String exchange) async {
    final endpoint = Endpoints.getInstrumentsExchange.replaceAll(
      '{exchange}',
      exchange,
    );

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    return parseInstrumentsCSV(response);
  }

  /// Gets all mutual fund instruments
  Future<MFInstruments> getMFInstruments() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.getMfInstruments,
    );

    return parseMFInstrumentsCSV(response);
  }

  /// Parse CSV data into list of Instrument objects
  Instruments parseInstrumentsCSV(String csv) {
    final lines = csv.trim().split(RegExp(r'\r?\n'));
    if (lines.isEmpty) return [];

    final dataLines = lines.skip(1);
    final instruments = <Instrument>[];

    for (final line in dataLines) {
      if (line.trim().isEmpty) continue;
      final fields = parseCSVLine(line);
      if (fields.length < 12) continue;

      instruments.add(Instrument(
        instrumentToken: int.parse(fields[0]),
        exchangeToken: int.parse(fields[1]),
        tradingsymbol: fields[2].trim(),
        name: fields[3].trim().isEmpty ? '' : fields[3].trim(),
        lastPrice: fields[4].trim().isEmpty ? 0.0 : double.parse(fields[4]),
        expiry: fields[5].trim().isEmpty ? null : DateTime.parse(fields[5]),
        strike: fields[6].trim().isEmpty ? 0.0 : double.parse(fields[6]),
        tickSize: fields[7].trim().isEmpty ? 0.0 : double.parse(fields[7]),
        lotSize: fields[8].trim().isEmpty ? 0.0 : double.parse(fields[8]),
        instrumentType: fields[9].trim(),
        segment: fields[10].trim(),
        exchange: fields[11].trim(),
      ));
    }

    return instruments;
  }

  /// Parse CSV data into list of MFInstrument objects
  MFInstruments parseMFInstrumentsCSV(String csv) {
    final lines = csv.trim().split(RegExp(r'\r?\n'));
    if (lines.isEmpty) return [];

    final dataLines = lines.skip(1);
    final instruments = <MFInstrument>[];

    for (final line in dataLines) {
      if (line.trim().isEmpty) continue;
      final fields = parseCSVLine(line);
      if (fields.length < 16) continue;

      instruments.add(MFInstrument(
        tradingsymbol: fields[0].trim(),
        amc: fields[1].trim(),
        name: fields[2].trim(),
        purchaseAllowed: fields[3].trim() == '1',
        redemptionAllowed: fields[4].trim() == '1',
        minimumPurchaseAmount: fields[5].trim().isEmpty ? 0.0 : double.parse(fields[5]),
        purchaseAmountMultiplier: fields[6].trim().isEmpty ? 0.0 : double.parse(fields[6]),
        minimumAdditionalPurchaseAmount: fields[7].trim().isEmpty ? 0.0 : double.parse(fields[7]),
        minimumRedemptionQuantity: fields[8].trim().isEmpty ? 0.0 : double.parse(fields[8]),
        redemptionQuantityMultiplier: fields[9].trim().isEmpty ? 0.0 : double.parse(fields[9]),
        dividendType: fields[10].trim(),
        schemeType: fields[11].trim(),
        plan: fields[12].trim(),
        settlementType: fields[13].trim(),
        lastPrice: fields[14].trim().isEmpty ? 0.0 : double.parse(fields[14]),
        lastPriceDate: fields[15].trim().isEmpty ? null : DateTime.parse(fields[15]),
      ));
    }

    return instruments;
  }

  /// Simple CSV line parser that handles quoted fields
  List<String> parseCSVLine(String line) {
    final fields = <String>[];
    final buffer = StringBuffer();
    bool inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];

      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        fields.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    fields.add(buffer.toString());
    return fields;
  }
}
