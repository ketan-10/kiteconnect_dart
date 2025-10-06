import 'package:test/test.dart';
import 'package:kiteconnect_dart/kite_connect.dart';
import 'package:kiteconnect_dart/models/order_models.dart';
import 'mock_server.dart';

void main() {
  group('Order Tests', () {
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

    test('getOrders should return all orders', () async {
      final orders = await kite.getOrders();

      expect(orders, isNotEmpty);
      expect(orders[0].orderId, equals('100000000000000'));
      expect(orders[0].status, equals('CANCELLED'));
      expect(orders[0].exchange, equals('CDS'));
      expect(orders[0].tradingsymbol, equals('USDINR21JUNFUT'));

      expect(orders[1].orderId, equals('300000000000000'));
      expect(orders[1].status, equals('COMPLETE'));
      expect(orders[1].exchange, equals('NSE'));
    });

    test('getTrades should return all trades', () async {
      final trades = await kite.getTrades();

      expect(trades, isNotEmpty);
      expect(trades[0].tradeId, equals('10000000'));
      expect(trades[0].orderId, equals('200000000000000'));
      expect(trades[0].exchange, equals('NSE'));
      expect(trades[0].tradingsymbol, equals('SBIN'));

      expect(trades[1].tradeId, equals('40000000'));
      expect(trades[1].exchange, equals('CDS'));
    });

    test('getOrderHistory should return order history', () async {
      final orderHistory = await kite.getOrderHistory('151220000000000');

      expect(orderHistory, isNotEmpty);
      for (final order in orderHistory) {
        expect(order.orderId, isNotEmpty);
        expect(order.tradingsymbol, isNotEmpty);
      }
    });

    test('getOrderTrades should return trades for order', () async {
      final orderTrades = await kite.getOrderTrades('151220000000000');

      expect(orderTrades, isNotEmpty);
      for (final trade in orderTrades) {
        expect(trade.tradeId, isNotEmpty);
      }
    });

    test('placeOrder should place regular order', () async {
      final orderParams = OrderParams(
        exchange: 'NSE',
        tradingsymbol: 'INFY',
        transactionType: 'BUY',
        quantity: 1,
        product: 'CNC',
        orderType: 'LIMIT',
        price: 1500.0,
      );

      final orderResponse = await kite.placeOrder('regular', orderParams);

      expect(orderResponse.orderId, isNotEmpty);
    });

    test('placeOrder should place iceberg order', () async {
      final orderParams = OrderParams(
        exchange: 'NSE',
        tradingsymbol: 'SBIN',
        transactionType: 'BUY',
        quantity: 1000,
        product: 'CNC',
        orderType: 'LIMIT',
        price: 463.0,
        icebergLegs: 5,
        icebergQuantity: 200,
      );

      final orderResponse = await kite.placeOrder('iceberg', orderParams);

      expect(orderResponse.orderId, isNotEmpty);
    });

    test('placeOrder should place cover order', () async {
      final orderParams = OrderParams(
        exchange: 'NSE',
        tradingsymbol: 'INFY',
        transactionType: 'BUY',
        quantity: 1,
        product: 'MIS',
        orderType: 'LIMIT',
        price: 1500.0,
        triggerPrice: 1490.0,
      );

      final orderResponse = await kite.placeOrder('co', orderParams);

      expect(orderResponse.orderId, isNotEmpty);
    });

    test('placeOrder should place auction order', () async {
      final orderParams = OrderParams(
        exchange: 'NSE',
        tradingsymbol: 'BHEL',
        transactionType: 'SELL',
        quantity: 60,
        product: 'CNC',
        orderType: 'LIMIT',
        price: 85.0,
        auctionNumber: '22',
      );

      final orderResponse = await kite.placeOrder('auction', orderParams);

      expect(orderResponse.orderId, isNotEmpty);
    });

    test('modifyOrder should modify order', () async {
      final orderParams = OrderParams(
        quantity: 2,
        price: 1510.0,
      );

      final orderResponse =
          await kite.modifyOrder('regular', '151220000000000', orderParams);

      expect(orderResponse.orderId, isNotEmpty);
    });

    test('cancelOrder should cancel order', () async {
      final orderResponse =
          await kite.cancelOrder('regular', '151220000000000');

      expect(orderResponse.orderId, isNotEmpty);
    });

    test('exitOrder should cancel order', () async {
      final orderResponse = await kite.exitOrder('regular', '151220000000000');

      expect(orderResponse.orderId, isNotEmpty);
    });
  });
}
