import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:kiteconnect_dart/constants.dart';

class ApiEndpointMappings {
  static Map<String, Map<String, String>> getEndpoints() {
    final endpoints = <String, Map<String, String>>{};

    // Format: METHOD:PATH -> MOCK_FILE
    // User endpoints
    endpoints['GET:${Endpoints.userProfile}'] = {'file': 'profile.json'};
    endpoints['GET:${Endpoints.userFullProfile}'] = {
      'file': 'full_profile.json'
    };
    endpoints['GET:${Endpoints.userMargins}'] = {'file': 'margins.json'};
    endpoints['GET:/user/margins/equity'] = {
      'file': 'margins_equity.json'
    }; // Specific segment for testing

    // Session endpoints
    endpoints['POST:${Endpoints.sessionGenerate}'] = {
      'file': 'generate_session.json'
    };
    endpoints['DELETE:${Endpoints.invalidateToken}'] = {
      'file': 'session_logout.json'
    };
    endpoints['POST:${Endpoints.renewAccess}'] = {
      'file': 'generate_session.json'
    }; // Using same file for refresh token

    // Portfolio endpoints
    endpoints['GET:${Endpoints.getPositions}'] = {'file': 'positions.json'};
    endpoints['GET:${Endpoints.getHoldings}'] = {'file': 'holdings.json'};
    endpoints['POST:${Endpoints.initHoldingsAuth}'] = {
      'file': 'holdings_auth.json'
    };
    endpoints['GET:${Endpoints.auctionInstruments}'] = {
      'file': 'auctions_list.json'
    };
    endpoints['PUT:${Endpoints.convertPosition}'] = {
      'file': 'convert_position.json'
    };

    // Order endpoints
    endpoints['GET:${Endpoints.getOrders}'] = {'file': 'orders.json'};
    endpoints['GET:${Endpoints.getTrades}'] = {'file': 'trades.json'};
    endpoints['GET:/orders/151220000000000'] = {
      'file': 'order_info.json'
    }; // Mock order ID
    endpoints['GET:/orders/151220000000000/trades'] = {
      'file': 'order_trades.json'
    }; // Mock order ID
    endpoints['POST:/orders/regular'] = {
      'file': 'order_response.json'
    }; // Mock variety
    endpoints['POST:/orders/iceberg'] = {
      'file': 'order_response.json' }; // Mock variety
    endpoints['POST:/orders/co'] = {'file': 'order_response.json'}; // Mock variety
    endpoints['POST:/orders/auction'] = {
      'file': 'order_response.json'
    }; // Mock variety
    endpoints['PUT:/orders/regular/151220000000000'] = {
      'file': 'order_modify.json'
    }; // Mock variety and order ID
    endpoints['DELETE:/orders/regular/151220000000000'] = {
      'file': 'order_response.json'
    }; // Mock variety and order ID

    // Mutual Fund endpoints
    endpoints['GET:${Endpoints.getMfOrders}'] = {'file': 'mf_orders.json'};
    endpoints['GET:/mf/orders/test'] = {
      'file': 'mf_orders_info.json'
    }; // Mock order ID
    endpoints['POST:${Endpoints.placeMfOrder}'] = {
      'file': 'order_response.json'
    }; // Use existing order response format
    endpoints['DELETE:/mf/orders/test'] = {
      'file': 'order_response.json'
    }; // Mock order ID
    endpoints['GET:${Endpoints.getMfSips}'] = {'file': 'mf_sips.json'};
    endpoints['GET:/mf/sips/test'] = {'file': 'mf_sip_info.json'}; // Mock SIP ID
    endpoints['POST:${Endpoints.placeMfSip}'] = {'file': 'mf_sip_place.json'};
    endpoints['PUT:/mf/sips/test'] = {
      'file': 'mf_sip_info.json'
    }; // Use mf_sip_info.json
    endpoints['DELETE:/mf/sips/test'] = {
      'file': 'mf_sip_cancel.json'
    }; // Mock SIP ID
    endpoints['GET:${Endpoints.getMfHoldings}'] = {'file': 'mf_holdings.json'};
    endpoints['GET:/mf/holdings/test'] = {
      'file': 'mf_holdings.json'
    }; // Mock ISIN

    // Margin endpoints
    endpoints['POST:${Endpoints.orderMargins}'] = {
      'file': 'order_margins.json'
    };
    endpoints['POST:${Endpoints.basketMargins}'] = {
      'file': 'basket_margins.json'
    };
    endpoints['POST:${Endpoints.orderCharges}'] = {
      'file': 'virtual_contract_note.json'
    };

    // Market data endpoints
    endpoints['GET:${Endpoints.getQuote}'] = {'file': 'quote.json'};
    endpoints['GET:${Endpoints.getLtp}'] = {'file': 'ltp.json'};
    endpoints['GET:${Endpoints.getOhlc}'] = {'file': 'ohlc.json'};
    endpoints['GET:/instruments/historical/123/myinterval'] = {
      'file': 'historical_minute.json'
    }; // Mock instrument token and interval
    endpoints['GET:/instruments/historical/456/myinterval'] = {
      'file': 'historical_oi.json'
    }; // Mock instrument token with OI
    endpoints['GET:/instruments/NSE/INFY/trigger_range'] = {
      'file': 'trigger_range.json'
    }; // Mock exchange and tradingsymbol

    // Alerts API endpoints
    endpoints['POST:/alerts'] = {'file': 'alerts_create.json'};
    endpoints['GET:/alerts'] = {'file': 'alerts_get.json'};
    endpoints['GET:/alerts/550e8400-e29b-41d4-a716-446655440000'] = {
      'file': 'alerts_get_one.json'
    };
    endpoints['PUT:/alerts/550e8400-e29b-41d4-a716-446655440000'] = {
      'file': 'alerts_modify.json'
    };
    endpoints['DELETE:/alerts'] = {'file': 'alerts_delete.json'};
    endpoints['GET:/alerts/550e8400-e29b-41d4-a716-446655440000/history'] = {
      'file': 'alerts_history.json'
    };

    // CSV endpoints
    endpoints['GET:${Endpoints.getInstruments}'] = {
      'file': 'instruments_all.csv',
      'type': 'csv'
    };
    endpoints['GET:/instruments/nse'] = {
      'file': 'instruments_nse.csv',
      'type': 'csv'
    };
    endpoints['GET:${Endpoints.getMfInstruments}'] = {
      'file': 'mf_instruments.csv',
      'type': 'csv'
    };

    return endpoints;
  }
}

class KiteMockServer {
  final String baseUrl;
  final Map<String, Map<String, String>> _endpointMap;

  KiteMockServer({String? baseUrl})
      : baseUrl = baseUrl ?? 'https://api.kite.trade',
        _endpointMap = ApiEndpointMappings.getEndpoints();

  http.Client createMockClient() {
    return MockClient((request) async {
      final method = request.method.toUpperCase();
      final path = request.url.path;
      final key = '$method:$path';

      // Look up the endpoint in our map
      final endpointConfig = _endpointMap[key];

      if (endpointConfig != null) {
        final mockFile = endpointConfig['file']!;
        final fileType = endpointConfig['type'] ?? 'json';

        if (fileType == 'csv') {
          final csvData = _loadCsvData(mockFile);
          return http.Response(
            csvData,
            200,
            headers: {'content-type': 'text/csv'},
          );
        } else {
          final mockData = _loadMockData(mockFile);
          return http.Response(
            jsonEncode(mockData),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
      }

      // Return 404 for unmocked endpoints
      return http.Response(
        jsonEncode({
          'status': 'error',
          'message': 'Endpoint not mocked: $key',
          'error_type': 'GeneralException'
        }),
        404,
      );
    });
  }

  String _loadCsvData(String filename) {
    final mockPath = 'test/mocks/$filename';
    try {
      return File(mockPath).readAsStringSync();
    } catch (e) {
      throw Exception('Failed to read mock CSV file: $mockPath - $e');
    }
  }

  dynamic _loadMockData(String filename) {
    final mockPath = 'test/mocks/$filename';
    try {
      final mockData = File(mockPath).readAsStringSync();
      return jsonDecode(mockData);
    } catch (e) {
      throw Exception('Failed to read mock file: $mockPath - $e');
    }
  }
}
