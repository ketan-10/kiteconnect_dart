import 'package:test/test.dart';
import 'package:kiteconnect_dart/kite_connect.dart';
import 'mock_server.dart';

void main() {
  group('Market Data Tests', () {
    late KiteMockServer mockServer;
    late KiteConnect kite;

    setUp(() {
      mockServer = KiteMockServer();

      kite = KiteConnect(
        apiKey: 'test_api_key',
        baseUrl: mockServer.baseUrl,
        timeout: const Duration(seconds: 10),
        httpClient: mockServer.createMockClient(),
      );

      kite.setAccessToken('test_access_token');
    });

    test('getQuote should return full quotes for instruments', () async {
      final quotes = await kite.getQuote(['NSE:INFY', 'NSE:SBIN']);

      expect(quotes, isNotEmpty);
      expect(quotes['NSE:INFY'], isNotNull);
      expect(quotes['NSE:INFY']!.instrumentToken, isNotNull);
      expect(quotes['NSE:INFY']!.lastPrice, isNotNull);
      expect(quotes['NSE:INFY']!.ohlc, isNotNull);
    });

    test('getLTP should return last traded prices', () async {
      final ltps = await kite.getLTP(['NSE:INFY', 'NSE:SBIN']);

      expect(ltps, isNotEmpty);
      expect(ltps['NSE:INFY'], isNotNull);
      expect(ltps['NSE:INFY']!.instrumentToken, isNotNull);
      expect(ltps['NSE:INFY']!.lastPrice, greaterThan(0));
    });

    test('getOHLC should return OHLC data', () async {
      final ohlcData = await kite.getOHLC(['NSE:INFY', 'NSE:SBIN']);

      expect(ohlcData, isNotEmpty);
      expect(ohlcData['NSE:INFY'], isNotNull);
      expect(ohlcData['NSE:INFY']!.ohlc, isNotNull);
      expect(ohlcData['NSE:INFY']!.ohlc.open, greaterThan(0));
      expect(ohlcData['NSE:INFY']!.ohlc.high, greaterThan(0));
    });

    test('getHistoricalData should return historical candle data', () async {
      final historicalData = await kite.getHistoricalData(
        123,
        'myinterval',
        '2021-01-01',
        '2021-01-31',
      );

      expect(historicalData, isNotEmpty);
      expect(historicalData[0].open, greaterThan(0));
      expect(historicalData[0].high, greaterThan(0));
      expect(historicalData[0].low, greaterThan(0));
      expect(historicalData[0].close, greaterThan(0));
    });

    test('getHistoricalData with OI should return data with OI', () async {
      final historicalData = await kite.getHistoricalData(
        456,
        'myinterval',
        '2021-01-01',
        '2021-01-31',
        oi: true,
      );

      expect(historicalData, isNotEmpty);
      expect(historicalData[0].oi, greaterThanOrEqualTo(0));
    });

    test('getInstruments should return all instruments', () async {
      final instruments = await kite.getInstruments();

      expect(instruments, isNotEmpty);
      expect(instruments[0].instrumentToken, isNotNull);
      expect(instruments[0].tradingsymbol, isNotEmpty);
      expect(instruments[0].exchange, isNotEmpty);
    });

    test('getInstrumentsByExchange should return instruments for exchange',
        () async {
      final instruments = await kite.getInstrumentsByExchange('nse');

      expect(instruments, isNotEmpty);
      expect(instruments[0].exchange, equals('NSE'));
    });

    test('getMFInstruments should return MF instruments', () async {
      final mfInstruments = await kite.getMFInstruments();

      expect(mfInstruments, isNotEmpty);
      expect(mfInstruments[0].tradingsymbol, isNotEmpty);
      expect(mfInstruments[0].amc, isNotEmpty);
    });
  });
}
