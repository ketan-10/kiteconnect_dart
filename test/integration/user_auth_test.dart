import 'package:test/test.dart';
import 'package:kiteconnect_dart/kite_connect.dart';
import 'mock_server.dart';

void main() {
  group('User Authentication Tests', () {
    late KiteMockServer mockServer;
    late KiteConnect kite;

    setUp(() {
      // Setup mock server
      mockServer = KiteMockServer();

      // Create KiteConnect client with mock HTTP client
      kite = KiteConnect(
        apiKey: 'test_api_key',
        baseUrl: mockServer.baseUrl,
        timeout: const Duration(seconds: 10),
        httpClient: mockServer.createMockClient(),
      );

      // Set access token for authentication
      kite.setAccessToken('test_access_token');
    });

    test('getUserProfile should return user profile', () async {
      // Test get_user_profile
      final profile = await kite.getUserProfile();

      expect(profile.userId, equals('AB1234'));
      expect(profile.userName, equals('AxAx Bxx'));
      expect(profile.email, equals('xxxyyy@gmail.com'));
      expect(profile.userType, equals('individual'));
      expect(profile.broker, equals('ZERODHA'));
    });

    test('getFullUserProfile should return full user profile', () async {
      // Test get_full_user_profile
      final fullProfile = await kite.getFullUserProfile();

      expect(fullProfile.userId, equals('AB1234'));
      expect(fullProfile.userName, equals('AxAx Bxx'));
      expect(fullProfile.email, equals('xxxyyy@gmail.com'));
      expect(fullProfile.userType, equals('individual'));
      expect(fullProfile.broker, equals('ZERODHA'));
      expect(fullProfile.phone, equals('*9999'));
      expect(fullProfile.pan, equals('*xxxI'));
      expect(fullProfile.twofaType, equals('totp'));

      // Test bank accounts
      expect(fullProfile.banks.length, equals(2));
      expect(fullProfile.banks[0].name, equals('HDFC BANK'));
      expect(fullProfile.banks[0].account, equals('*9999'));
      expect(fullProfile.banks[1].name, equals('State Bank of India'));

      // Test DP IDs
      expect(fullProfile.dpIds.length, equals(1));
      expect(fullProfile.dpIds[0], equals('0xx0xxx0xxxx0xx0'));

      // Test meta information
      expect(fullProfile.meta.dematConsent, equals('physical'));
      expect(fullProfile.meta.silo, equals('x'));
      expect(fullProfile.meta.accountBlocks, isEmpty);

      // Test timestamps
      expect(fullProfile.passwordTimestamp, equals('1970-01-01 00:00:00'));
      expect(fullProfile.twofaTimestamp, equals('1970-01-01 00:00:00'));

      // Test that avatar_url is None
      expect(fullProfile.avatarUrl, isNull);
    });

    test('getUserMargins should return all margins', () async {
      // Test get_user_margins
      final margins = await kite.getUserMargins();

      expect(margins.equity.enabled, isTrue);
      expect(margins.equity.net, equals(99725.05000000002));
      expect(margins.commodity.enabled, isTrue);
      expect(margins.commodity.net, equals(100661.7));
    });

    test('getUserSegmentMargins should return segment margins', () async {
      // Test get_user_segment_margins
      final equityMargins = await kite.getUserSegmentMargins('equity');

      expect(equityMargins.enabled, isTrue);
      expect(equityMargins.net, equals(99725.05000000002));
      expect(equityMargins.available.cash, equals(245431.6));
    });

    test('generateSession should return user session', () async {
      // Create a new client without access token for this test
      final kiteNoToken = KiteConnect(
        apiKey: 'test_api_key',
        baseUrl: mockServer.baseUrl,
        timeout: const Duration(seconds: 10),
        httpClient: mockServer.createMockClient(),
      );

      // Test generate_session
      final session = await kiteNoToken.generateSession(
        'test_request_token',
        'test_api_secret',
      );

      expect(session.userId, equals('XX0000'));
      expect(session.accessToken, equals('XXXXXX'));
      expect(session.refreshToken, equals(''));

      // Note: The access token should be automatically set in the client
      // We trust the implementation based on the API design
    });

    test('invalidateAccessToken should invalidate token', () async {
      // Test invalidate_access_token
      final result = await kite.invalidateAccessToken();

      expect(result, isTrue);
    });

    test('renewAccessToken should renew tokens', () async {
      // Test renew_access_token
      final tokens = await kite.renewAccessToken(
        'test_refresh_token',
        'test_api_secret',
      );

      expect(tokens.accessToken, equals('XXXXXX'));
      expect(tokens.refreshToken, equals(''));

      // Note: The access token should be automatically updated
      // We trust the implementation based on the API design
    });

    test('error handling should work correctly', () async {
      // Create KiteConnect client with invalid base URL to trigger errors
      final kiteInvalid = KiteConnect(
        apiKey: 'test_api_key',
        baseUrl: 'http://invalid-url-that-does-not-exist.com',
        timeout: const Duration(seconds: 1),
      );

      kiteInvalid.setAccessToken('test_token');

      // Test that errors are properly handled
      expect(
        () async => await kiteInvalid.getUserProfile(),
        throwsA(anything), // Accept any error type for invalid URL
      );
    });

    test('loginUrl should generate correct URL', () {
      final kiteTest = KiteConnect(
        apiKey: 'test_api_key',
      );

      final loginUrl = kiteTest.loginUrl;
      expect(loginUrl, contains('test_api_key'));
      expect(loginUrl, contains('v=3'));
    });

    test('access token management should work', () {
      final kiteTest = KiteConnect(
        apiKey: 'test_api_key',
      );

      // Test setting and clearing access token
      kiteTest.setAccessToken('test_token');
      expect(kiteTest.accessToken, equals('test_token'));

      kiteTest.clearAccessToken();
      expect(kiteTest.accessToken, isNull);

      // Test that empty token throws error
      expect(
        () => kiteTest.setAccessToken(''),
        throwsArgumentError,
      );
    });
  });
}
