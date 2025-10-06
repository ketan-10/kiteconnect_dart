import 'package:kiteconnect_dart/constants.dart';
import 'package:kiteconnect_dart/models/portfolio_models.dart';
import 'package:kiteconnect_dart/kite_connect.dart';

/// Mixin providing portfolio management methods
mixin PortfolioMethods on KiteConnectBase {
  /// Get a list of holdings
  Future<Holdings> getHoldings() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.getHoldings,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => Holding.fromJson(e)).toList();
  }

  /// Get auction instruments - retrieves list of available instruments for an auction session
  Future<List<AuctionInstrument>> getAuctionInstruments() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.auctionInstruments,
    );

    final data = unwrapResponse(response);
    return (data as List).map((e) => AuctionInstrument.fromJson(e)).toList();
  }

  /// Get user positions
  Future<Positions> getPositions() async {
    final response = await performRequest(
      RequestMethod.get,
      Endpoints.getPositions,
    );

    return Positions.fromJson(unwrapResponse(response));
  }

  /// Convert position's product type
  Future<bool> convertPosition(ConvertPositionParams positionParams) async {
    await performRequest(
      RequestMethod.put,
      Endpoints.convertPosition,
      formFields: positionParams.toFormFields(),
    );
    return true;
  }

  /// Initiate holdings authorization flow
  ///
  /// It accepts an optional list of HoldingsAuthInstruments which can be used to specify
  /// a set of ISINs with their respective quantities. Since, the isin and quantity pairs
  /// here are optional, you can provide it as null. If they're provided, authorization
  /// is sought only for those instruments and otherwise, the entire holdings is presented
  /// for authorization. The response contains the RequestID which can then be used to
  /// redirect the user in a web view. The client forms and returns the formed RedirectURL as well.
  Future<HoldingsAuthResp> initiateHoldingsAuth(
    HoldingAuthParams authParams,
  ) async {
    final params = <String, String>{};

    // Convert the params object to JSON first
    final jsonParams = authParams.toJson();

    // Add all non-null string fields
    if (jsonParams['type'] != null &&
        jsonParams['type'].toString().isNotEmpty) {
      params['type'] = jsonParams['type'];
    }
    if (jsonParams['transfer_type'] != null &&
        jsonParams['transfer_type'].toString().isNotEmpty) {
      params['transfer_type'] = jsonParams['transfer_type'];
    }
    if (jsonParams['exec_date'] != null &&
        jsonParams['exec_date'].toString().isNotEmpty) {
      params['exec_date'] = jsonParams['exec_date'];
    }

    // Handle optional instruments - form fields need special handling for arrays
    if (authParams.instruments != null) {
      for (final instrument in authParams.instruments!) {
        params['isin'] = instrument.isin;
        params['quantity'] = instrument.quantity.toString();
      }
    }

    final response = await performRequest(
      RequestMethod.post,
      Endpoints.initHoldingsAuth,
      formFields: params,
    );

    final resp = HoldingsAuthResp.fromJson(unwrapResponse(response));

    // Form and set the URL in the response
    final loginUrl =
        '${AppConstants.kiteBaseUrl}/connect/portfolio/authorise/holdings/$apiKey/${resp.requestId}';

    return HoldingsAuthResp(requestId: resp.requestId, redirectUrl: loginUrl);
  }
}
