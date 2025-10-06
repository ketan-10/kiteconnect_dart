import 'package:kiteconnect_dart/constants.dart';
import 'package:kiteconnect_dart/models/order_models.dart';
import 'package:kiteconnect_dart/kite_connect.dart';

/// Mixin providing order management methods
mixin OrderMethods on KiteConnectBase {
  /// Gets list of orders
  Future<Orders> getOrders() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.getOrders,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => Order.fromJson(e)).toList();
  }

  /// Gets list of trades
  Future<Trades> getTrades() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.getTrades,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => Trade.fromJson(e)).toList();
  }

  /// Gets history of an individual order
  Future<List<Order>> getOrderHistory(String orderId) async {
    final endpoint = Endpoints.getOrderHistory.replaceAll('{order_id}', orderId);

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => Order.fromJson(e)).toList();
  }

  /// Gets list of trades executed for a particular order
  Future<List<Trade>> getOrderTrades(String orderId) async {
    final endpoint = Endpoints.getOrderTrades.replaceAll('{order_id}', orderId);

    final response = await performRequest(
      RequestMethod.get,
      endpoint,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => Trade.fromJson(e)).toList();
  }

  /// Places an order
  Future<OrderResponse> placeOrder(
    String variety,
    OrderParams orderParams,
  ) async {
    final endpoint = Endpoints.placeOrder.replaceAll('{variety}', variety);

    final response = await performRequest(
      RequestMethod.post,
      endpoint,
      formFields: orderParams.toFormFields(),
    );

    return OrderResponse.fromJson(unwrapResponse(response));
  }

  /// Modifies an order
  Future<OrderResponse> modifyOrder(
    String variety,
    String orderId,
    OrderParams orderParams,
  ) async {
    final endpoint = Endpoints.modifyOrder
        .replaceAll('{variety}', variety)
        .replaceAll('{order_id}', orderId);

    final response = await performRequest(
      RequestMethod.put,
      endpoint,
      formFields: orderParams.toFormFields(),
    );

    return OrderResponse.fromJson(unwrapResponse(response));
  }

  /// Cancels/exits an order
  Future<OrderResponse> cancelOrder(
    String variety,
    String orderId, {
    String? parentOrderId,
  }) async {
    final endpoint = Endpoints.cancelOrder
        .replaceAll('{variety}', variety)
        .replaceAll('{order_id}', orderId);

    final params = <String, String>{};
    if (parentOrderId != null) {
      params['parent_order_id'] = parentOrderId;
    }

    final response = await performRequest(
      RequestMethod.delete,
      endpoint,
      formFields: params.isNotEmpty ? params : null,
    );

    return OrderResponse.fromJson(unwrapResponse(response));
  }

  /// Alias for cancelOrder which is used to cancel/exit an order
  Future<OrderResponse> exitOrder(
    String variety,
    String orderId, {
    String? parentOrderId,
  }) async {
    return cancelOrder(variety, orderId, parentOrderId: parentOrderId);
  }
}
