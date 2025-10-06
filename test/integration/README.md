# Integration Tests for KiteConnect Dart

This directory contains integration tests for the KiteConnect Dart SDK, similar to the Rust implementation in `test/integration-rs/`.

## Structure

- `mock_server.dart` - Mock server setup using http MockClient
- `user_auth_test.dart` - User authentication and profile tests (✓ Complete)
- `order_test.dart` - Order management tests (✓ Complete)
- `portfolio_test.dart` - Portfolio and positions tests (✓ Complete)
- `markets_test.dart` - Market data tests (✓ Complete)
- `margins_test.dart` - Margin calculation tests (✓ Complete)
- `mf_test.dart` - Mutual fund tests (✓ Complete)
- `alerts_test.dart` - GTT/Alert tests (✓ Complete)

## Running Tests

```bash
# Run all tests
dart test

# Run specific test file
dart test test/integration/user_auth_test.dart

# Run with verbose output
dart test --reporter=expanded
```

## Mock Data

All tests use mock JSON responses from `test/mocks/` directory, which are shared with the Rust tests.

## Test Coverage

All integration tests are now complete:
- ✓ User profile and authentication (10 tests)
- ✓ User margins
- ✓ Session generation and token management
- ✓ Portfolio - positions, holdings, auctions, convert position (5 tests)
- ✓ Orders - place, modify, cancel, get orders, get trades (11 tests)
- ✓ Mutual funds - orders, SIPs, holdings (5 tests)
- ✓ Market data - quotes, OHLC, LTP, historical data, instruments (8 tests)
- ✓ Margins - order margins, basket margins, order charges (5 tests)
- ✓ Alerts/GTT - create, modify, delete, get, history (6 tests)

**Total: 51 integration tests**
