import 'package:flutter/foundation.dart';
import '../../interfaces/api_service_interface.dart';
import '../../services/api_service.dart';
import '../../services/service_locator.dart';
import '../../services/analytics_tracking_service.dart';
import '../../utils/error_types.dart';

class AnalyticsProvider with ChangeNotifier {
  final IApiService _apiService = getIt<IApiService>();
  final AnalyticsTrackingService _analytics = AnalyticsTrackingService();
  
  Map<String, dynamic>? _overview;
  Map<String, dynamic>? _trends;
  Map<String, dynamic>? _sentiment;
  bool _isLoading = false;
  String? _error;
  ErrorType? _errorType;
  
  Map<String, dynamic>? get overview => _overview;
  Map<String, dynamic>? get trends => _trends;
  Map<String, dynamic>? get sentiment => _sentiment;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ErrorType? get errorType => _errorType;
  
  /// Load analytics overview
  Future<void> loadOverview() async {
    _isLoading = true;
    _error = null;
    _errorType = null;
    notifyListeners();
    
    final stopwatch = Stopwatch()..start();
    
    try {
      _analytics.trackApiCall('/analytics/overview', success: true);
      final data = await _apiService.getAnalyticsOverview();
      _overview = data;
      _error = null;
      _errorType = null;
      
      stopwatch.stop();
      _analytics.trackApiCall('/analytics/overview', success: true, duration: stopwatch.elapsed);
      _analytics.trackEvent('analytics_overview_loaded');
    } on ApiException catch (e) {
      stopwatch.stop();
      _analytics.trackApiCall('/analytics/overview', success: false, duration: stopwatch.elapsed);
      _analytics.trackError('analytics_overview_error', e.message, parameters: {
        'error_type': e.type.toString(),
      });
      _error = e.message;
      _errorType = e.type;
    } catch (e) {
      stopwatch.stop();
      _analytics.trackApiCall('/analytics/overview', success: false, duration: stopwatch.elapsed);
      _analytics.trackError('analytics_overview_error', e.toString());
      _error = e.toString();
      _errorType = ErrorType.unknown;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load market trends for a specific timeframe
  Future<void> loadTrends(String timeframe) async {
    _isLoading = true;
    _error = null;
    _errorType = null;
    notifyListeners();
    
    final stopwatch = Stopwatch()..start();
    
    try {
      _analytics.trackApiCall('/analytics/trends', success: true);
      final data = await _apiService.getAnalyticsTrends(timeframe);
      _trends = data;
      _error = null;
      _errorType = null;
      
      stopwatch.stop();
      _analytics.trackApiCall('/analytics/trends', success: true, duration: stopwatch.elapsed);
      _analytics.trackEvent('analytics_trends_loaded', parameters: {
        'timeframe': timeframe,
      });
    } on ApiException catch (e) {
      stopwatch.stop();
      _analytics.trackApiCall('/analytics/trends', success: false, duration: stopwatch.elapsed);
      _analytics.trackError('analytics_trends_error', e.message, parameters: {
        'error_type': e.type.toString(),
        'timeframe': timeframe,
      });
      _error = e.message;
      _errorType = e.type;
    } catch (e) {
      stopwatch.stop();
      _analytics.trackApiCall('/analytics/trends', success: false, duration: stopwatch.elapsed);
      _analytics.trackError('analytics_trends_error', e.toString(), parameters: {
        'timeframe': timeframe,
      });
      _error = e.toString();
      _errorType = ErrorType.unknown;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load market sentiment data
  Future<void> loadSentiment() async {
    _isLoading = true;
    _error = null;
    _errorType = null;
    notifyListeners();
    
    final stopwatch = Stopwatch()..start();
    
    try {
      _analytics.trackApiCall('/analytics/sentiment', success: true);
      final data = await _apiService.getAnalyticsSentiment();
      _sentiment = data;
      _error = null;
      _errorType = null;
      
      stopwatch.stop();
      _analytics.trackApiCall('/analytics/sentiment', success: true, duration: stopwatch.elapsed);
      _analytics.trackEvent('analytics_sentiment_loaded');
    } on ApiException catch (e) {
      stopwatch.stop();
      _analytics.trackApiCall('/analytics/sentiment', success: false, duration: stopwatch.elapsed);
      _analytics.trackError('analytics_sentiment_error', e.message, parameters: {
        'error_type': e.type.toString(),
      });
      _error = e.message;
      _errorType = e.type;
    } catch (e) {
      stopwatch.stop();
      _analytics.trackApiCall('/analytics/sentiment', success: false, duration: stopwatch.elapsed);
      _analytics.trackError('analytics_sentiment_error', e.toString());
      _error = e.toString();
      _errorType = ErrorType.unknown;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
