import 'package:test/test.dart';
import 'package:kiteconnect_dart/kite_connect.dart';
import 'package:kiteconnect_dart/models/margin_models.dart';
import 'mock_server.dart';

void main() {
  group('Margins Tests', () {
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

    test('getOrderMargins should return margin requirements', () async {
      final orderParams = [
        OrderMarginParam(
          exchange: 'NSE',
          tradingSymbol: 'INFY',
          transactionType: 'BUY',
          variety: 'regular',
          product: 'CNC',
          orderType: 'MARKET',
          quantity: 1,
        ),
      ];

      final params = GetMarginParams(orderParams: orderParams);
      final margins = await kite.getOrderMargins(params);

      expect(margins, isNotEmpty);
      expect(margins[0].total, greaterThan(0));
      expect(margins[0].tradingSymbol, isNotEmpty);
      expect(margins[0].exchange, isNotEmpty);
    });

    test('getOrderMargins with compact mode should work', () async {
      final orderParams = [
        OrderMarginParam(
          exchange: 'NSE',
          tradingSymbol: 'INFY',
          transactionType: 'BUY',
          variety: 'regular',
          product: 'CNC',
          orderType: 'MARKET',
          quantity: 1,
        ),
      ];

      final params = GetMarginParams(orderParams: orderParams, compact: true);
      final margins = await kite.getOrderMargins(params);

      expect(margins, isNotEmpty);
      expect(margins[0].total, greaterThan(0));
    });

    test('getBasketMargins should return basket margin', () async {
      final orderParams = [
        OrderMarginParam(
          exchange: 'NSE',
          tradingSymbol: 'INFY',
          transactionType: 'BUY',
          variety: 'regular',
          product: 'CNC',
          orderType: 'MARKET',
          quantity: 1,
        ),
      ];

      final params = GetBasketParams(orderParams: orderParams);
      final basketMargins = await kite.getBasketMargins(params);

      expect(basketMargins.orders, isNotEmpty);
    });

    test('getBasketMargins with options should work', () async {
      final orderParams = [
        OrderMarginParam(
          exchange: 'NSE',
          tradingSymbol: 'INFY',
          transactionType: 'BUY',
          variety: 'regular',
          product: 'CNC',
          orderType: 'MARKET',
          quantity: 1,
        ),
      ];

      final params = GetBasketParams(
        orderParams: orderParams,
        compact: true,
        considerPositions: true,
      );
      final basketMargins = await kite.getBasketMargins(params);

      expect(basketMargins.orders, isNotEmpty);
    });

    test('getOrderCharges should return order charges', () async {
      final orderParams = [
        OrderChargesParam(
          orderId: '151220000000000',
          exchange: 'NSE',
          tradingSymbol: 'INFY',
          transactionType: 'BUY',
          variety: 'regular',
          product: 'CNC',
          orderType: 'MARKET',
          quantity: 1,
          averagePrice: 1500.0,
        ),
      ];

      final params = GetChargesParams(orderParams: orderParams);
      final charges = await kite.getOrderCharges(params);

      expect(charges, isNotEmpty);
      expect(charges[0].charges, isNotNull);
      expect(charges[0].charges.total, greaterThanOrEqualTo(0));
    });
  });
}
