import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kiteconnect_dart/constants.dart';
import 'package:kiteconnect_dart/models/common/error_models.dart';

// Import all modular mixins
import 'src/user.dart';
import 'src/portfolio.dart';
import 'src/orders.dart';
import 'src/mf.dart';
import 'src/markets.dart';
import 'src/margins.dart';
import 'src/alerts.dart';

enum RequestMethod { get, post, put, delete, patch }

/// Base class providing HTTP client functionality for mixins
abstract class KiteConnectBase {
  final String baseUrl;
  final Duration timeout;
  final String apiKey;
  String? accessToken;
  final http.Client? httpClient;

  KiteConnectBase({
    required this.apiKey,
    this.accessToken,
    this.baseUrl = AppConstants.defaultBaseUrl,
    this.timeout = AppConstants.defaultTimeout,
    this.httpClient,
  });

  void setAccessToken(String token) {
    if (token.isEmpty) throw ArgumentError('Token cannot be empty');
    accessToken = token;
  }

  void clearAccessToken() {
    accessToken = null;
  }

  Map<String, String> getHeaders(Map<String, String>? headers) {
    final defaultHeaders = {
      'X-Kite-Version': AppConstants.kiteHeaderVersion,
      'User-Agent':
          '${AppConstants.kiteConnectName}/${AppConstants.kiteConnectVersion}',
    };
    if (headers != null) {
      defaultHeaders.addAll(headers);
    }
    return defaultHeaders;
  }

  /// Unwrap the API response to extract the data field
  dynamic unwrapResponse(String response) {
    final jsonResponse = jsonDecode(response);
    return jsonResponse['data'] ?? jsonResponse;
  }

  Future<String> performRequest(
    RequestMethod method,
    String url, {
    Map<String, String>? headers,
    dynamic body,
    Map<String, String>? formFields,
  }) async {
    final client = httpClient ?? http.Client();
    final request = http.Request(method.name, Uri.parse('$baseUrl$url'));

    request.headers.addAll(getHeaders(headers));

    if (body != null) {
      request.body = jsonEncode(body);
      request.headers['Content-Type'] = 'application/json';
    } else if (formFields != null) {
      request.bodyFields = formFields;
      request.headers['Content-Type'] = 'application/x-www-form-urlencoded';
    }

    final streamResponse = await client
        .send(request)
        .timeout(
          timeout,
          onTimeout: () => throw TimeoutException('Request timed out'),
        );

    if (streamResponse.statusCode < 200 || streamResponse.statusCode >= 300) {
      final errorResponse = await streamResponse.stream.bytesToString();
      throw KiteErrorMessage.fromJson(jsonDecode(errorResponse));
    }

    final reseponseBody = await streamResponse.stream.bytesToString();
    return reseponseBody;
  }
}

/// Provides access to all Kite Connect APIs including:
/// - User profile and session management
/// - Portfolio (holdings, positions, auctions)
/// - Orders (place, modify, cancel, history)
/// - Mutual funds
/// - Market data (quotes, historical, instruments)
/// - Margin calculations
/// - Alerts (GTT)
class KiteConnect extends KiteConnectBase
    with
        UserMethods,
        PortfolioMethods,
        OrderMethods,
        MFMethods,
        MarketMethods,
        MarginMethods,
        AlertMethods {
  KiteConnect({
    required super.apiKey,
    super.accessToken,
    super.baseUrl,
    super.timeout,
    super.httpClient,
  });

  /// Get login URL for user authentication
  String get loginUrl {
    return '${AppConstants.kiteBaseUrl}${Endpoints.loginUrl}?api_key=$apiKey&v=${AppConstants.kiteHeaderVersion}';
  }
}
