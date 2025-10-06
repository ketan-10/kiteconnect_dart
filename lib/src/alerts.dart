import 'package:kiteconnect_dart/constants.dart';
import 'package:kiteconnect_dart/models/alert_models.dart';
import 'package:kiteconnect_dart/kite_connect.dart';

/// Mixin providing alert (GTT) methods
mixin AlertMethods on KiteConnectBase {
  /// Create a new alert
  Future<Alert> createAlert(AlertParams params) async {
    final response = await performRequest(
      RequestMethod.post,
      Endpoints.alertsUrl,
      formFields: params.toFormFields(),
    );

    return Alert.fromJson(unwrapResponse(response));
  }

  /// Get all alerts with optional filters
  Future<List<Alert>> getAlerts([Map<String, String>? filters]) async {
    var endpoint = Endpoints.alertsUrl;

    if (filters != null && filters.isNotEmpty) {
      final queryParams = filters.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      endpoint = '$endpoint?$queryParams';
    }

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => Alert.fromJson(e)).toList();
  }

  /// Get a specific alert by UUID
  Future<Alert> getAlert(String uuid) async {
    final endpoint = Endpoints.alertUrl.replaceAll('{alert_id}', uuid);

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    return Alert.fromJson(unwrapResponse(response));
  }

  /// Modify an existing alert
  Future<Alert> modifyAlert(String uuid, AlertParams params) async {
    final endpoint = Endpoints.alertUrl.replaceAll('{alert_id}', uuid);

    final response = await performRequest(
      RequestMethod.put,
      endpoint,
      formFields: params.toFormFields(),
    );

    return Alert.fromJson(unwrapResponse(response));
  }

  /// Delete alerts by UUIDs
  Future<bool> deleteAlerts(List<String> uuids) async {
    if (uuids.isEmpty) {
      throw ArgumentError('At least one UUID must be provided');
    }

    final queryParams = uuids.map((uuid) => 'uuid=$uuid').join('&');
    final endpoint = '${Endpoints.alertsUrl}?$queryParams';

    await performRequest(
      RequestMethod.delete,
      endpoint,
    );

    return true;
  }

  /// Get alert history
  Future<List<AlertHistory>> getAlertHistory(String uuid) async {
    final endpoint = Endpoints.getAlertHistory.replaceAll('{alert_id}', uuid);

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => AlertHistory.fromJson(e)).toList();
  }
}
