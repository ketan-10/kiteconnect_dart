import 'package:kiteconnect_dart/constants.dart';
import 'package:kiteconnect_dart/models/mf_models.dart';
import 'package:kiteconnect_dart/kite_connect.dart';

/// Mixin providing mutual fund methods
mixin MFMethods on KiteConnectBase {
  /// Gets list of mutual fund orders
  Future<MFOrders> getMFOrders() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.getMfOrders,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => MFOrder.fromJson(e)).toList();
  }

  /// Gets list of mutual fund orders for a custom date range
  Future<MFOrders> getMFOrdersByDate(String fromDate, String toDate) async {
    final endpoint = '${Endpoints.getMfOrders}?from=$fromDate&to=$toDate';

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => MFOrder.fromJson(e)).toList();
  }

  /// Gets individual mutual fund order info
  Future<MFOrder> getMFOrderInfo(String orderId) async {
    final endpoint = Endpoints.getMfOrderInfo.replaceAll('{order_id}', orderId);

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    return MFOrder.fromJson(unwrapResponse(response));
  }

  /// Gets list of user mutual fund holdings
  Future<MFHoldings> getMFHoldings() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.getMfHoldings,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => MFHolding.fromJson(e)).toList();
  }

  /// Gets list of mutual fund SIPs
  Future<MFSIPs> getMFSIPs() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.getMfSips,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => MFSIP.fromJson(e)).toList();
  }

  /// Gets individual SIP info
  Future<MFSIP> getMFSIPInfo(String sipId) async {
    final endpoint = Endpoints.getMfSipInfo.replaceAll('{sip_id}', sipId);

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    return MFSIP.fromJson(unwrapResponse(response));
  }

  /// Gets list of user mutual fund allotted ISINs
  Future<MFAllottedISINs> getMFAllottedISINs() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.getMfAllottedIsins,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => e.toString()).toList();
  }
}
