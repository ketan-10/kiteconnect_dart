import 'package:test/test.dart';
import 'package:kiteconnect_dart/kite_connect.dart';
import 'mock_server.dart';

void main() {
  group('Mutual Fund Tests', () {
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

    test('getMFOrders should return all MF orders', () async {
      final orders = await kite.getMFOrders();

      expect(orders, isNotEmpty);
      expect(orders[0].orderId, isNotEmpty);
      expect(orders[0].tradingsymbol, isNotEmpty);
      expect(orders[0].fund, isNotEmpty);
    });

    test('getMFOrderInfo should return MF order info', () async {
      final order = await kite.getMFOrderInfo('test');

      expect(order.orderId, isNotEmpty);
      expect(order.tradingsymbol, isNotEmpty);
    });

    test('getMFSIPs should return all MF SIPs', () async {
      final sips = await kite.getMFSIPs();

      expect(sips, isNotEmpty);
      expect(sips[0].sipId, isNotEmpty);
      expect(sips[0].tradingsymbol, isNotEmpty);
    });

    test('getMFSIPInfo should return SIP info', () async {
      final sip = await kite.getMFSIPInfo('test');

      expect(sip.sipId, isNotEmpty);
      expect(sip.tradingsymbol, isNotEmpty);
    });

    test('getMFHoldings should return all MF holdings', () async {
      final holdings = await kite.getMFHoldings();

      expect(holdings, isNotEmpty);
      expect(holdings[0].tradingsymbol, isNotEmpty);
      expect(holdings[0].folio, isNotEmpty);
      expect(holdings[0].fund, isNotEmpty);
    });

    // TODO: Add mock data for allotted ISINs endpoint
    // test('getMFAllottedISINs should return allotted ISINs', () async {
    //   final isins = await kite.getMFAllottedISINs();
    //
    //   expect(isins, isNotEmpty);
    //   for (final isin in isins) {
    //     expect(isin, isNotEmpty);
    //   }
    // });
  });
}
