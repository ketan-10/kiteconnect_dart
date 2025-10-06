import 'package:kiteconnect_dart/constants.dart';
import 'package:kiteconnect_dart/models/margin_models.dart';
import 'package:kiteconnect_dart/kite_connect.dart';

/// Mixin providing margin calculation methods
mixin MarginMethods on KiteConnectBase {
  /// Get order margins for a list of orders
  Future<List<OrderMargins>> getOrderMargins(GetMarginParams params) async {
    var endpoint = Endpoints.orderMargins;
    if (params.compact) {
      endpoint = '$endpoint?mode=compact';
    }

    final body = params.orderParams.map((e) => e.toJson()).toList();

    final response = await performRequest(
      RequestMethod.post,
      endpoint,
      body: body,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => OrderMargins.fromJson(e)).toList();
  }

  /// Get basket margins for a list of orders
  Future<BasketMargins> getBasketMargins(GetBasketParams params) async {
    var endpoint = Endpoints.basketMargins;
    final queryParams = <String>[];

    if (params.compact) {
      queryParams.add('mode=compact');
    }
    if (params.considerPositions) {
      queryParams.add('consider_positions=true');
    }

    if (queryParams.isNotEmpty) {
      endpoint = '$endpoint?${queryParams.join('&')}';
    }

    final body = params.orderParams.map((e) => e.toJson()).toList();

    final response = await performRequest(
      RequestMethod.post,
      endpoint,
      body: body,
    );

    return BasketMargins.fromJson(unwrapResponse(response));
  }

  /// Get order charges for a list of orders
  Future<List<OrderCharges>> getOrderCharges(GetChargesParams params) async {
    final body = params.orderParams.map((e) => e.toJson()).toList();

    final response = await performRequest(
      RequestMethod.post,
      Endpoints.orderCharges,
      body: body,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => OrderCharges.fromJson(e)).toList();
  }
}
