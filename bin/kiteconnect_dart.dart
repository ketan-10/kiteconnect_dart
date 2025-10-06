import 'package:kiteconnect_dart/kite_ticker.dart';
import 'package:kiteconnect_dart/models/ticker_models.dart';
import 'package:kiteconnect_dart/models/order_models.dart';

void main() {
  // Initialize with your API key and access token
  const apiKey = 'your_api_key';
  const accessToken = 'your_access_token';

  final ticker = KiteTicker(
    apiKey: apiKey,
    accessToken: accessToken,
    autoReconnect: true,
    maxRetry: 50,
    maxDelay: 60,
  );

  // Register event listeners
  ticker.onConnect(() {
    print('WebSocket connected');

    // Subscribe to instruments
    const tokens = [738561, 256265]; // Example: Reliance, Nifty 50
    ticker.subscribe(tokens);

    // Set mode to full (includes market depth and other details)
    ticker.setMode(KiteTicker.modeFull, tokens);
  });

  ticker.onTicks((List<Tick> ticks) {
    print('Received ${ticks.length} ticks');

    for (final tick in ticks) {
      if (tick is LTPTick) {
        print('LTP Tick - Token: ${tick.instrumentToken}, Price: ${tick.lastPrice}');
      } else if (tick is QuoteTick) {
        print('Quote Tick - Token: ${tick.instrumentToken}, '
            'Price: ${tick.lastPrice}, '
            'Change: ${tick.change.toStringAsFixed(2)}%');
        print('  OHLC: O=${tick.ohlc.open}, H=${tick.ohlc.high}, '
            'L=${tick.ohlc.low}, C=${tick.ohlc.close}');
      } else if (tick is FullTick) {
        print('Full Tick - Token: ${tick.instrumentToken}');
        print('  Price: ${tick.lastPrice}, Volume: ${tick.volumeTradedToday}');
        print('  Change: ${tick.change.toStringAsFixed(2)}%');
        print('  OHLC: O=${tick.ohlc.open}, H=${tick.ohlc.high}, '
            'L=${tick.ohlc.low}, C=${tick.ohlc.close}');
        print('  Buy Qty: ${tick.totalBuyQuantity}, Sell Qty: ${tick.totalSellQuantity}');

        if (tick.depth != null) {
          print('  Market Depth:');
          print('    Top Bid: ${tick.depth!.buy.first.price} (${tick.depth!.buy.first.quantity})');
          print('    Top Ask: ${tick.depth!.sell.first.price} (${tick.depth!.sell.first.quantity})');
        }

        if (tick.oi != null) {
          print('  OI: ${tick.oi}, OI High: ${tick.oiDayHigh}, OI Low: ${tick.oiDayLow}');
        }
      }
    }
  });

  ticker.onDisconnect((error) {
    print('WebSocket disconnected: $error');
  });

  ticker.onError((error) {
    print('Error occurred: $error');
  });

  ticker.onClose((reason) {
    print('Connection closed: $reason');
  });

  ticker.onReconnect((attempt, interval) {
    print('Reconnecting: attempt $attempt, interval ${interval}s');
  });

  ticker.onNoReconnect(() {
    print('Maximum reconnection attempts reached. Giving up.');
  });

  ticker.onOrderUpdate((Order order) {
    print('Order update received:');
    print('  Order ID: ${order.orderId}');
    print('  Status: ${order.status}');
    print('  Tradingsymbol: ${order.tradingsymbol}');
  });

  ticker.onMessage((binaryData) {
    print('Raw binary message received: ${binaryData.length} bytes');
  });

  // Connect to the WebSocket
  print('Connecting to Kite ticker...');
  ticker.connect();

  // To disconnect later (in a real app, you'd do this on app close or user action)
  // ticker.disconnect();
}

/// Example: Subscribe to additional tokens dynamically
void subscribeMore(KiteTicker ticker) {
  const additionalTokens = [408065, 779521]; // Example tokens
  ticker.subscribe(additionalTokens);
}

/// Example: Unsubscribe from tokens
void unsubscribeTokens(KiteTicker ticker) {
  const tokensToRemove = [738561];
  ticker.unsubscribe(tokensToRemove);
}

/// Example: Change mode for subscribed tokens
void changeMode(KiteTicker ticker) {
  const tokens = [256265];
  // Change from full mode to quote mode to reduce data
  ticker.setMode(KiteTicker.modeQuote, tokens);
}

/// Example: Advanced usage with auto-reconnection tuning
void advancedExample() {
  const apiKey = 'your_api_key';
  const accessToken = 'your_access_token';

  final ticker = KiteTicker(
    apiKey: apiKey,
    accessToken: accessToken,
    autoReconnect: true,
    maxRetry: 10,  // Try reconnecting up to 10 times
    maxDelay: 30,  // Max 30 seconds between attempts
  );

  // You can also configure reconnection after initialization
  ticker.autoReconnect(true, 20, 45);

  ticker.onConnect(() {
    print('Connected!');

    // Subscribe to multiple instruments with different modes
    const ltpTokens = [738561]; // Reliance - only need LTP
    const quoteTokens = [256265]; // Nifty - need quote data
    const fullTokens = [408065]; // Some F&O instrument - need full depth

    ticker.subscribe([...ltpTokens, ...quoteTokens, ...fullTokens]);

    // Set different modes for different tokens
    ticker.setMode(KiteTicker.modeLTP, ltpTokens);
    ticker.setMode(KiteTicker.modeQuote, quoteTokens);
    ticker.setMode(KiteTicker.modeFull, fullTokens);
  });

  ticker.onTicks((ticks) {
    // Process ticks
    for (final tick in ticks) {
      // Handle different tick types
      switch (tick.mode) {
        case KiteTicker.modeLTP:
          handleLTPTick(tick as LTPTick);
          break;
        case KiteTicker.modeQuote:
          handleQuoteTick(tick as QuoteTick);
          break;
        case KiteTicker.modeFull:
          handleFullTick(tick as FullTick);
          break;
      }
    }
  });

  ticker.connect();
}

void handleLTPTick(LTPTick tick) {
  print('LTP: ${tick.instrumentToken} = ${tick.lastPrice}');
}

void handleQuoteTick(QuoteTick tick) {
  print('Quote: ${tick.instrumentToken} = ${tick.lastPrice} (${tick.change.toStringAsFixed(2)}%)');
}

void handleFullTick(FullTick tick) {
  print('Full: ${tick.instrumentToken} = ${tick.lastPrice}, Vol: ${tick.volumeTradedToday}');
}
