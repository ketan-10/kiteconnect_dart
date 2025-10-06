# KiteConnect Dart - Test Suite

This directory contains comprehensive test coverage for the KiteConnect Dart SDK.

## Test Structure

```
test/
├── kiteconnect_dart_test.dart    # Unit tests for KiteConnect class
├── integration/                   # Integration tests with mock server
│   ├── mock_server.dart          # Mock HTTP client implementation
│   ├── user_auth_test.dart       # User authentication & profile (10 tests)
│   ├── portfolio_test.dart       # Portfolio & positions (5 tests)
│   ├── order_test.dart           # Order management (11 tests)
│   ├── mf_test.dart              # Mutual funds (5 tests)
│   ├── markets_test.dart         # Market data (8 tests)
│   ├── margins_test.dart         # Margin calculations (5 tests)
│   ├── alerts_test.dart          # GTT/Alerts (6 tests)
│   └── README.md                 # Integration tests documentation
└── mocks/                        # Mock JSON/CSV data files

```

## Test Coverage Summary

### KiteConnect Core Tests (41 tests)
Comprehensive tests covering **ALL** KiteConnect API endpoints using mock server:
- **User Endpoints** (4 tests) - getUserProfile, getFullUserProfile, getUserMargins, getUserSegmentMargins
- **Session Endpoints** (3 tests) - generateSession, invalidateAccessToken, renewAccessToken
- **Portfolio Endpoints** (5 tests) - getHoldings, initiateHoldingsAuth, getPositions, getAuctionInstruments, convertPosition
- **Order Endpoints** (7 tests) - getOrders, getTrades, getOrderHistory, getOrderTrades, placeOrder, modifyOrder, cancelOrder
- **Mutual Fund Endpoints** (5 tests) - getMFOrders, getMFOrderInfo, getMFSIPs, getMFSIPInfo, getMFHoldings
- **Market Data Endpoints** (8 tests) - getQuote, getLTP, getOHLC, getHistoricalData (2 tests), getInstruments, getInstrumentsByExchange, getMFInstruments
- **Margin Endpoints** (3 tests) - getOrderMargins, getBasketMargins, getOrderCharges
- **Alert Endpoints** (6 tests) - createAlert, getAlerts, getAlert, modifyAlert, deleteAlerts, getAlertHistory

### Integration Tests (51 tests)
Detailed end-to-end tests organized by feature area:
- **User Authentication** (10 tests) - Profile, margins, session management
- **Portfolio** (5 tests) - Holdings, positions, auctions, conversion
- **Orders** (11 tests) - Place, modify, cancel, history, trades
- **Mutual Funds** (5 tests) - Orders, SIPs, holdings
- **Market Data** (8 tests) - Quotes, OHLC, LTP, historical, instruments
- **Margins** (5 tests) - Order margins, basket margins, charges
- **Alerts/GTT** (6 tests) - Create, modify, delete, get, history

**Total: 92 tests** covering all mock endpoints

## Running Tests

### Run All Tests
```bash
dart test
```

### Run Unit Tests Only
```bash
dart test test/kiteconnect_dart_test.dart
```

### Run Integration Tests Only
```bash
dart test test/integration/
```

### Run Specific Test File
```bash
dart test test/integration/order_test.dart
```

### Run with Verbose Output
```bash
dart test --reporter=expanded
```

### Run with Code Coverage
```bash
dart test --coverage=coverage
dart pub global activate coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
```

## Mock Data

All integration tests use mock JSON/CSV responses from the `test/mocks/` directory. These mock files are shared with the Rust implementation in `test/integration-rs/` to ensure consistency across language implementations.

## Test Patterns

### Unit Tests
Unit tests follow the AAA (Arrange-Act-Assert) pattern:
```dart
test('should initialize with required parameters', () {
  // Arrange
  final apiKey = 'test_api_key';

  // Act
  final kite = KiteConnect(apiKey: apiKey);

  // Assert
  expect(kite.apiKey, equals(apiKey));
});
```

### Integration Tests
Integration tests use a mock HTTP client to simulate API responses:
```dart
test('getOrders should return all orders', () async {
  // Setup mock server with test data
  final kite = KiteConnect(
    apiKey: 'test_api_key',
    httpClient: mockServer.createMockClient(),
  );

  // Execute method
  final orders = await kite.getOrders();

  // Verify results
  expect(orders, isNotEmpty);
  expect(orders[0].orderId, isNotEmpty);
});
```

## Continuous Integration

All tests must pass before merging pull requests. The test suite runs automatically on:
- Every commit to main branch
- Every pull request
- Before each release

## Contributing

When adding new features:
1. Add unit tests for any new public methods
2. Add integration tests with corresponding mock data
3. Ensure all tests pass: `dart test`
4. Maintain test coverage above 80%

## Test Data

Mock data files follow Kite Connect API response format:
```json
{
  "status": "success",
  "data": { ... }
}
```

CSV files for instrument data use the official format from Kite Connect instruments endpoint.
