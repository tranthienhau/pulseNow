import 'package:flutter/foundation.dart';

/// Service for tracking user analytics and events
class AnalyticsTrackingService {
  static final AnalyticsTrackingService _instance = AnalyticsTrackingService._internal();
  factory AnalyticsTrackingService() => _instance;
  AnalyticsTrackingService._internal();

  // In-memory storage for events (in production, you'd send to analytics service)
  final List<AnalyticsEvent> _events = [];
  bool _isEnabled = true;

  /// Enable or disable analytics tracking
  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  /// Track a screen view
  void trackScreenView(String screenName, {Map<String, dynamic>? parameters}) {
    if (!_isEnabled) return;
    
    _logEvent('screen_view', {
      'screen_name': screenName,
      ...?parameters,
    });
  }

  /// Track a user action/event
  void trackEvent(String eventName, {Map<String, dynamic>? parameters}) {
    if (!_isEnabled) return;
    
    _logEvent(eventName, parameters ?? {});
  }

  /// Track market data interaction
  void trackMarketDataInteraction(String action, {String? symbol, Map<String, dynamic>? parameters}) {
    if (!_isEnabled) return;
    
    _logEvent('market_data_$action', {
      if (symbol != null) 'symbol': symbol,
      ...?parameters,
    });
  }

  /// Track search event
  void trackSearch(String query, {int? resultCount}) {
    if (!_isEnabled) return;
    
    _logEvent('search', {
      'query': query,
      if (resultCount != null) 'result_count': resultCount,
    });
  }

  /// Track sort event
  void trackSort(String sortBy, {bool? ascending}) {
    if (!_isEnabled) return;
    
    _logEvent('sort', {
      'sort_by': sortBy,
      if (ascending != null) 'ascending': ascending,
    });
  }

  /// Track navigation event
  void trackNavigation(String from, String to, {Map<String, dynamic>? parameters}) {
    if (!_isEnabled) return;
    
    _logEvent('navigation', {
      'from': from,
      'to': to,
      ...?parameters,
    });
  }

  /// Track error event
  void trackError(String errorType, String errorMessage, {Map<String, dynamic>? parameters}) {
    if (!_isEnabled) return;
    
    _logEvent('error', {
      'error_type': errorType,
      'error_message': errorMessage,
      ...?parameters,
    });
  }

  /// Track API call
  void trackApiCall(String endpoint, {bool success = true, int? statusCode, Duration? duration}) {
    if (!_isEnabled) return;
    
    _logEvent('api_call', {
      'endpoint': endpoint,
      'success': success,
      if (statusCode != null) 'status_code': statusCode,
      if (duration != null) 'duration_ms': duration.inMilliseconds,
    });
  }

  /// Get all tracked events (for debugging/testing)
  List<AnalyticsEvent> getEvents() => List.unmodifiable(_events);

  /// Clear all events
  void clearEvents() {
    _events.clear();
  }

  void _logEvent(String eventName, Map<String, dynamic> parameters) {
    final event = AnalyticsEvent(
      name: eventName,
      parameters: parameters,
      timestamp: DateTime.now(),
    );
    
    _events.add(event);
    
    // In production, you would send this to your analytics service
    // For now, we just log it
    debugPrint('Analytics: $eventName - $parameters');
    
    // Keep only last 100 events in memory
    if (_events.length > 100) {
      _events.removeAt(0);
    }
  }
}

/// Analytics event model
class AnalyticsEvent {
  final String name;
  final Map<String, dynamic> parameters;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.name,
    required this.parameters,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'parameters': parameters,
    'timestamp': timestamp.toIso8601String(),
  };
}
