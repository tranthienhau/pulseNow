import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../services/cached_api_service.dart';
import '../../services/api_service.dart';
import '../../interfaces/cache_service_interface.dart';
import '../../interfaces/websocket_service_interface.dart';
import '../../services/service_locator.dart';
import '../../models/market_data_model.dart';
import '../../utils/error_types.dart';

class MarketDataProvider with ChangeNotifier {
  final CachedApiService _apiService = CachedApiService();
  final ICacheService _cacheService = getIt<ICacheService>();
  final IWebSocketService _webSocketService = getIt<IWebSocketService>();
  
  List<MarketData> _marketData = [];
  bool _isLoading = false;
  String? _error;
  ErrorType? _errorType;
  bool _isOffline = false;
  DateTime? _lastUpdated;
  bool _isWebSocketConnected = false;
  StreamSubscription<Map<String, dynamic>>? _webSocketSubscription;
  StreamSubscription<bool>? _connectionStatusSubscription;
  
  List<MarketData> get marketData => _marketData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ErrorType? get errorType => _errorType;
  bool get isOffline => _isOffline;
  DateTime? get lastUpdated => _lastUpdated;
  bool get isWebSocketConnected => _isWebSocketConnected;
  
  /// Get market data for a specific symbol
  MarketData? getMarketDataBySymbol(String symbol) {
    try {
      return _marketData.firstWhere((item) => item.symbol == symbol);
    } catch (e) {
      return null;
    }
  }
  
  /// Load market data with cache support
  Future<void> loadMarketData({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    _errorType = null;
    _isOffline = false;
    notifyListeners();
    
    try {
      // If not forcing refresh, try to load from cache first for instant display
      if (!forceRefresh) {
        final cachedData = await _apiService.getMarketDataFromCache();
        if (cachedData != null && cachedData.isNotEmpty) {
          _marketData = cachedData.map((json) => MarketData.fromJson(json)).toList();
          _lastUpdated = await _cacheService.getCacheTimestamp();
          notifyListeners();
        }
      }
      
      // Try to fetch fresh data from API
      final data = await _apiService.getMarketData();
      _marketData = data.map((json) => MarketData.fromJson(json)).toList();
      _error = null;
      _errorType = null;
      _isOffline = false;
      _lastUpdated = DateTime.now();
      
      // Start WebSocket connection after initial load
      _startWebSocketConnection();
    } on ApiException catch (e) {
      // If we have cached data, show it but mark as offline
      if (_marketData.isNotEmpty) {
        _isOffline = true;
        // Don't set error if we have cached data
        // Still try to connect WebSocket for real-time updates
        _startWebSocketConnection();
      } else {
        _error = e.message;
        _errorType = e.type;
        _isOffline = (e.type == ErrorType.noInternet || e.type == ErrorType.timeout);
      }
    } catch (e) {
      // If we have cached data, show it
      if (_marketData.isEmpty) {
        _error = e.toString();
        _errorType = ErrorType.unknown;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Start WebSocket connection for real-time updates
  void _startWebSocketConnection() {
    // Cancel existing subscription if any
    _webSocketSubscription?.cancel();
    _connectionStatusSubscription?.cancel();

    // Connect WebSocket
    _webSocketService.connect();

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
        debugPrint('WebSocket stream error: $error');
      },
    );
  }

  /// Handle WebSocket market data update
  void _handleWebSocketUpdate(Map<String, dynamic> update) {
    try {
      final symbol = update['symbol'] as String?;
      if (symbol == null) return;

      // Find and update the market data item
      final index = _marketData.indexWhere((item) => item.symbol == symbol);
      if (index != -1) {
        // Update existing item
        final existingItem = _marketData[index];
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

        _marketData[index] = updatedItem;
        _lastUpdated = DateTime.now();
        
        // Update cache with new data
        _updateCache();
        
        notifyListeners();
      } else {
        // New item - add it if it's a valid market data
        try {
          final newItem = MarketData.fromJson(update);
          _marketData.add(newItem);
          _lastUpdated = DateTime.now();
          _updateCache();
          notifyListeners();
        } catch (e) {
          debugPrint('Error parsing new market data from WebSocket: $e');
        }
      }
    } catch (e) {
      debugPrint('Error handling WebSocket update: $e');
    }
  }

  /// Update cache with current market data
  Future<void> _updateCache() async {
    try {
      final dataToCache = _marketData.map((item) => {
        'symbol': item.symbol,
        'description': item.description,
        'price': item.price,
        'change24h': item.change24h,
        'changePercent24h': item.changePercent24h,
        'volume': item.volume,
        'high24h': item.high24h,
        'low24h': item.low24h,
        'marketCap': item.marketCap,
        'lastUpdated': item.lastUpdated,
      }).toList();
      await _cacheService.saveMarketData(dataToCache);
    } catch (e) {
      debugPrint('Error updating cache: $e');
    }
  }
  
  /// Load data from cache only (for offline mode)
  Future<void> loadFromCache() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final cachedData = await _apiService.getMarketDataFromCache();
      if (cachedData != null && cachedData.isNotEmpty) {
        _marketData = cachedData.map((json) => MarketData.fromJson(json)).toList();
        _lastUpdated = await _cacheService.getCacheTimestamp();
        _isOffline = true;
        _error = null;
        _errorType = null;
      } else {
        _error = 'No cached data available';
        _errorType = ErrorType.unknown;
      }
    } catch (e) {
      _error = e.toString();
      _errorType = ErrorType.unknown;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Clear cache
  Future<void> clearCache() async {
    await _apiService.clearCache();
    _marketData = [];
    notifyListeners();
  }

  /// Disconnect WebSocket
  void disconnectWebSocket() {
    _webSocketSubscription?.cancel();
    _webSocketSubscription = null;
    _connectionStatusSubscription?.cancel();
    _connectionStatusSubscription = null;
    _webSocketService.disconnect();
    _isWebSocketConnected = false;
    notifyListeners();
  }
}
