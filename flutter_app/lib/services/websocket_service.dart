import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../utils/constants.dart';
import '../interfaces/websocket_service_interface.dart';

class WebSocketService implements IWebSocketService {
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _controller;
  StreamController<bool>? _connectionStatusController;
  bool _isConnected = false;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 3);

  @override
  Stream<Map<String, dynamic>>? get stream => _controller?.stream;

  @override
  bool get isConnected => _isConnected;

  @override
  Stream<bool> get connectionStatus => _connectionStatusController?.stream ?? const Stream.empty();

  @override
  void connect() {
    if (_isConnected && _channel != null) {
      debugPrint('WebSocket already connected');
      return;
    }

    try {
      _controller ??= StreamController<Map<String, dynamic>>.broadcast();
      _connectionStatusController ??= StreamController<bool>.broadcast();

      debugPrint('Connecting to WebSocket: ${AppConstants.wsUrl}');
      _channel = WebSocketChannel.connect(Uri.parse(AppConstants.wsUrl));

      _subscription = _channel!.stream.listen(
        (message) {
          try {
            final data = json.decode(message) as Map<String, dynamic>;
            
            // Handle different message types
            if (data['type'] == 'market_update' && data.containsKey('data')) {
              _controller?.add(data['data'] as Map<String, dynamic>);
            } else {
              // Handle other message types or pass through
              _controller?.add(data);
            }
          } catch (e) {
            debugPrint('Error parsing WebSocket message: $e');
          }
        },
        onError: (error) {
          debugPrint('WebSocket error: $error');
          _handleDisconnection();
        },
        onDone: () {
          debugPrint('WebSocket connection closed');
          _handleDisconnection();
        },
        cancelOnError: false,
      );

      _isConnected = true;
      _reconnectAttempts = 0;
      _connectionStatusController?.add(true);
      debugPrint('WebSocket connected successfully');
    } catch (e) {
      debugPrint('Error connecting to WebSocket: $e');
      _isConnected = false;
      _connectionStatusController?.add(false);
      _scheduleReconnect();
    }
  }

  void _handleDisconnection() {
    if (_isConnected) {
      _isConnected = false;
      _connectionStatusController?.add(false);
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('Max reconnect attempts reached. Stopping reconnection.');
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(_reconnectDelay, () {
      _reconnectAttempts++;
      debugPrint('Attempting to reconnect WebSocket (attempt $_reconnectAttempts/$_maxReconnectAttempts)');
      connect();
    });
  }

  @override
  void disconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectAttempts = 0;
    
    _subscription?.cancel();
    _subscription = null;
    
    _channel?.sink.close();
    _channel = null;
    
    if (_isConnected) {
      _isConnected = false;
      _connectionStatusController?.add(false);
    }
    
    _controller?.close();
    _controller = null;
    
    _connectionStatusController?.close();
    _connectionStatusController = null;
    
    debugPrint('WebSocket disconnected');
  }

  /// Send message to WebSocket server
  void send(Map<String, dynamic> message) {
    if (_isConnected && _channel != null) {
      try {
        _channel!.sink.add(json.encode(message));
      } catch (e) {
        debugPrint('Error sending WebSocket message: $e');
      }
    } else {
      debugPrint('Cannot send message: WebSocket not connected');
    }
  }
}
