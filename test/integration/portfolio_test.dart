import 'package:test/test.dart';
import 'package:kiteconnect_dart/kite_connect.dart';
import 'package:kiteconnect_dart/models/portfolio_models.dart';
import 'mock_server.dart';

void main() {
  group('Portfolio Tests', () {
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

    test('getPositions should return all positions', () async {
      final positions = await kite.getPositions();

      expect(positions.net, isNotEmpty);
      expect(positions.day, isNotEmpty);

      // Verify first net position
      final firstNet = positions.net[0];
      expect(firstNet.tradingsymbol, isNotEmpty);
      expect(firstNet.exchange, isNotEmpty);
      expect(firstNet.instrumentToken, greaterThan(0));
    });

    test('getHoldings should return all holdings', () async {
      final holdings = await kite.getHoldings();

      expect(holdings, isNotEmpty);
      expect(holdings[0].tradingsymbol, isNotEmpty);
      expect(holdings[0].exchange, isNotEmpty);
      expect(holdings[0].instrumentToken, greaterThan(0));
      expect(holdings[0].isin, isNotEmpty);
    });

    test('getAuctionInstruments should return auction instruments', () async {
      final auctions = await kite.getAuctionInstruments();

      expect(auctions, isNotEmpty);
      expect(auctions[0].tradingsymbol, isNotEmpty);
      expect(auctions[0].auctionNumber, isNotEmpty);
    });

    test('convertPosition should convert position successfully', () async {
      final params = ConvertPositionParams(
        exchange: 'NSE',
        tradingsymbol: 'SBIN',
        oldProduct: 'CNC',
        newProduct: 'NRML',
        positionType: 'day',
        transactionType: 'BUY',
        quantity: 1,
      );

      final result = await kite.convertPosition(params);

      expect(result, isTrue);
    });

    test('initiateHoldingsAuth should return auth response', () async {
      final params = HoldingAuthParams(
        authType: 'holdings',
        transferType: 'sell',
        execDate: '2024-01-01',
      );

      final authResp = await kite.initiateHoldingsAuth(params);

      expect(authResp.requestId, isNotEmpty);
      expect(authResp.redirectUrl, isNotNull);
      expect(authResp.redirectUrl, contains('authorise/holdings'));
      expect(authResp.redirectUrl, contains(authResp.requestId));
    });
  });
}
