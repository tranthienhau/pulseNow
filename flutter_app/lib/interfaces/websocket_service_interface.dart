/// Interface for WebSocket service
abstract class IWebSocketService {
  /// Connect to WebSocket server
  void connect();
  
  /// Disconnect from WebSocket server
  void disconnect();
  
  /// Stream of market data updates
  Stream<Map<String, dynamic>>? get stream;
  
  /// Check if connected
  bool get isConnected;
  
  /// Connection status stream
  Stream<bool> get connectionStatus;
}
