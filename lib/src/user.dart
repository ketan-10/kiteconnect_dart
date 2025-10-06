import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:kiteconnect_dart/constants.dart';
import 'package:kiteconnect_dart/models/user_models.dart';
import 'package:kiteconnect_dart/kite_connect.dart';

/// Mixin providing user profile and session management methods
mixin UserMethods on KiteConnectBase {
  /// Get user profile
  Future<UserProfile> getUserProfile() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.userProfile,
    );

    return UserProfile.fromJson(unwrapResponse(response));
  }

  /// Get full user profile
  Future<FullUserProfile> getFullUserProfile() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.userFullProfile,
    );
    return FullUserProfile.fromJson(unwrapResponse(response));
  }

  /// Get all user margins
  Future<AllMargins> getUserMargins() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.userMargins,
    );

    return AllMargins.fromJson(unwrapResponse(response));
  }

  /// Get segment wise user margins
  Future<Margins> getUserSegmentMargins(String segment) async {
    final endpoint = Endpoints.userMarginsSegment.replaceAll(
      '{segment}',
      segment,
    );

    final response = await performRequest(RequestMethod.get, endpoint);

    return Margins.fromJson(unwrapResponse(response));
  }

  /// Generate session and set access token
  Future<UserSession> generateSession(
    String requestToken,
    String secret,
  ) async {
    final bytes = utf8.encode('$apiKey$requestToken$secret');
    final digest = sha256.convert(bytes);
    final checksum = digest.toString();

    final fromBody = {
      'api_key': apiKey,
      'request_token': requestToken,
      'checksum': checksum,
    };

    final response = await performRequest(
      RequestMethod.post,
      Endpoints.sessionGenerate,
      formFields: fromBody,
    );

    final session = UserSession.fromJson(unwrapResponse(response));

    setAccessToken(session.accessToken);
    return session;
  }

  /// Invalidate a token (access_token or refresh_token)
  Future<bool> _invalidateToken(String tokenType, String token) async {
    final formBody = {'api_key': apiKey, tokenType: token};

    await performRequest(
      RequestMethod.delete,
      Endpoints.invalidateToken,
      formFields: formBody,
    );
    return true;
  }

  /// Invalidate the current access token
  Future<bool> invalidateAccessToken() async {
    if (accessToken == null) return false;

    final result = await _invalidateToken('access_token', accessToken!);
    if (result) {
      clearAccessToken();
    }
    return result;
  }

  /// Renew expired access token using valid refresh token
  /// Access token is automatically set if the renewal is successful.
  Future<UserSessionTokens> renewAccessToken(
    String refreshToken,
    String apiSecret,
  ) async {
    final bytes = utf8.encode('$apiKey$refreshToken$apiSecret');
    final digest = sha256.convert(bytes);
    final checksum = digest.toString();

    final formBody = {
      'api_key': apiKey,
      'refresh_token': refreshToken,
      'checksum': checksum,
    };

    final response = await performRequest(
      RequestMethod.post,
      Endpoints.renewAccess,
      formFields: formBody,
    );

    final tokens = UserSessionTokens.fromJson(unwrapResponse(response));

    // Automatically set access token on successful renewal
    setAccessToken(tokens.accessToken);

    return tokens;
  }

  /// Invalidate the given refresh token
  Future<bool> invalidateRefreshToken(String refreshToken) async {
    return await _invalidateToken('refresh_token', refreshToken);
  }
}
