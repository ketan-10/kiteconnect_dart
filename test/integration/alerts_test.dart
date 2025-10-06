import 'package:test/test.dart';
import 'package:kiteconnect_dart/kite_connect.dart';
import 'package:kiteconnect_dart/models/alert_models.dart';
import 'mock_server.dart';

void main() {
  group('Alerts Tests', () {
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

    test('createAlert should create a new alert', () async {
      final alertParams = AlertParams(
        name: 'Test Alert',
        type: AlertType.simple,
        lhsExchange: 'NSE',
        lhsTradingsymbol: 'INFY',
        lhsAttribute: 'last_price',
        operator: AlertOperator.ge,
        rhsType: 'constant',
        rhsConstant: 1500.0,
      );

      final alert = await kite.createAlert(alertParams);

      expect(alert.uuid, isNotEmpty);
      expect(alert.name, isNotEmpty);
      expect(alert.type, equals(AlertType.simple));
    });

    test('getAlerts should return all alerts', () async {
      final alerts = await kite.getAlerts();

      expect(alerts, isNotEmpty);
      expect(alerts[0].uuid, isNotEmpty);
    });

    test('getAlert should return specific alert', () async {
      final alert = await kite.getAlert('550e8400-e29b-41d4-a716-446655440000');

      expect(alert.uuid, equals('550e8400-e29b-41d4-a716-446655440000'));
    });

    test('modifyAlert should update an alert', () async {
      final alertParams = AlertParams(
        name: 'Modified Alert',
        type: AlertType.simple,
        lhsExchange: 'NSE',
        lhsTradingsymbol: 'INFY',
        lhsAttribute: 'last_price',
        operator: AlertOperator.ge,
        rhsType: 'constant',
        rhsConstant: 1600.0,
      );

      final alert =
          await kite.modifyAlert('550e8400-e29b-41d4-a716-446655440000', alertParams);

      expect(alert.uuid, equals('550e8400-e29b-41d4-a716-446655440000'));
    });

    test('deleteAlerts should delete alerts', () async {
      final result = await kite.deleteAlerts(['550e8400-e29b-41d4-a716-446655440000']);

      expect(result, isTrue);
    });

    test('getAlertHistory should return alert history', () async {
      final history = await kite.getAlertHistory('550e8400-e29b-41d4-a716-446655440000');

      expect(history, isNotEmpty);
      expect(history[0].uuid, isNotEmpty);
    });
  });
}
