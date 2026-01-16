import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../interfaces/websocket_service_interface.dart';
import '../../services/service_locator.dart';
import '../../models/market_data_model.dart';

/// Provider for managing a single market data item's detail view
class MarketDetailProvider with ChangeNotifier {
  final IWebSocketService _webSocketService = getIt<IWebSocketService>();
  final String symbol;
  
  MarketData? _marketData;
  bool _isWebSocketConnected = false;
  StreamSubscription<Map<String, dynamic>>? _webSocketSubscription;
  StreamSubscription<bool>? _connectionStatusSubscription;
  
  MarketData? get marketData => _marketData;
  bool get isWebSocketConnected => _isWebSocketConnected;
  bool get hasData => _marketData != null;
  
  MarketDetailProvider({
    required this.symbol,
    MarketData? initialData,
  }) {
    _marketData = initialData;
    _startWebSocketConnection();
  }
  
  /// Start WebSocket connection for real-time updates
  void _startWebSocketConnection() {
    // Cancel existing subscription if any
    _webSocketSubscription?.cancel();
    _connectionStatusSubscription?.cancel();

    // Connect WebSocket if not already connected
    if (!_webSocketService.isConnected) {
      _webSocketService.connect();
    }

    // Listen to connection status
    _connectionStatusSubscription = _webSocketService.connectionStatus.listen((connected) {
      _isWebSocketConnected = connected;
      notifyListeners();
    });

    // Listen to market data updates
    _webSocketSubscription = _webSocketService.stream?.listen(
      (update) {
        _handleWebSocketUpdate(update);
      },
      onError: (error) {
        debugPrint('WebSocket stream error in MarketDetailProvider: $error');
      },
    );
  }

  /// Handle WebSocket market data update
  void _handleWebSocketUpdate(Map<String, dynamic> update) {
    try {
      final updateSymbol = update['symbol'] as String?;
      if (updateSymbol == null || updateSymbol != symbol) {
        // Not for this symbol, ignore
        return;
      }

      // Update market data
      if (_marketData != null) {
        // Update existing item
        final existingItem = _marketData!;
        final updatedItem = MarketData(
          symbol: symbol,
          description: existingItem.description,
          price: (update['price'] as num?)?.toDouble() ?? existingItem.price,
          change24h: (update['change24h'] as num?)?.toDouble() ?? existingItem.change24h,
          changePercent24h: existingItem.changePercent24h, // Calculate if needed
          volume: (update['volume'] as num?)?.toDouble() ?? existingItem.volume,
          high24h: existingItem.high24h,
          low24h: existingItem.low24h,
          marketCap: existingItem.marketCap,
          lastUpdated: update['timestamp'] as String? ?? existingItem.lastUpdated,
        );

        _marketData = updatedItem;
        notifyListeners();
      } else {
        // New item - create from update
        try {
          _marketData = MarketData.fromJson(update);
          notifyListeners();
        } catch (e) {
          debugPrint('Error parsing market data from WebSocket: $e');
        }
      }
    } catch (e) {
      debugPrint('Error handling WebSocket update in MarketDetailProvider: $e');
    }
  }

  /// Update market data manually (e.g., from API call)
  void updateMarketData(MarketData data) {
    if (data.symbol == symbol) {
      _marketData = data;
      notifyListeners();
    }
  }

  /// Refresh data (can be extended to fetch from API)
  Future<void> refresh() async {
    // This can be extended to fetch fresh data from API
    // For now, it just triggers a notification
    notifyListeners();
  }

  @override
  void dispose() {
    _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    _connectionStatusSubscription?.cancel();
    _connectionStatusSubscription = null;
    // Note: We don't disconnect the WebSocket service here
    // as it might be used by other providers
    super.dispose();
  }
}
