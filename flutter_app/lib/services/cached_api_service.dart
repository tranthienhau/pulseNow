import '../interfaces/api_service_interface.dart';
import 'api_service.dart';
import '../interfaces/cache_service_interface.dart';
import 'service_locator.dart';
import '../utils/error_types.dart';

/// API Service with caching support
class CachedApiService implements IApiService {
  final IApiService _apiService;
  final ICacheService _cacheService;

  CachedApiService({
    IApiService? apiService,
    ICacheService? cacheService,
  })  : _apiService = apiService ?? getIt<IApiService>(),
        _cacheService = cacheService ?? getIt<ICacheService>();

  @override
  Future<List<Map<String, dynamic>>> getMarketData() async {
    try {
      // Try to fetch from API first
      final data = await _apiService.getMarketData();
      
      // Save to cache on successful fetch
      await _cacheService.saveMarketData(data);
      
      return data;
    } on ApiException catch (e) {
      // If network error, try to get from cache
      if (e.type == ErrorType.noInternet || e.type == ErrorType.timeout) {
        final cachedData = await _cacheService.getMarketData();
        
        if (cachedData != null && cachedData.isNotEmpty) {
          // Return cached data but don't clear the error
          // The provider can handle showing offline indicator
          return cachedData;
        }
      }
      
      // Re-throw the exception if no cache available
      rethrow;
    } catch (e) {
      // For any other error, try cache as fallback
      final cachedData = await _cacheService.getMarketData();
      
      if (cachedData != null && cachedData.isNotEmpty) {
        return cachedData;
      }
      
      // Re-throw if no cache
      rethrow;
    }
  }

  /// Get market data from cache only (for offline mode)
  Future<List<Map<String, dynamic>>?> getMarketDataFromCache() async {
    return await _cacheService.getMarketData();
  }

  /// Check if valid cache exists
  Future<bool> hasValidCache({Duration? maxAge}) async {
    return await _cacheService.hasValidCache(maxAge: maxAge);
  }

  /// Clear cache
  Future<void> clearCache() async {
    await _cacheService.clearCache();
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsOverview() async {
    return await _apiService.getAnalyticsOverview();
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsTrends(String timeframe) async {
    return await _apiService.getAnalyticsTrends(timeframe);
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsSentiment() async {
    return await _apiService.getAnalyticsSentiment();
  }

  @override
  Future<Map<String, dynamic>> getPortfolioSummary() async {
    return await _apiService.getPortfolioSummary();
  }

  @override
  Future<List<Map<String, dynamic>>> getPortfolioHoldings() async {
    return await _apiService.getPortfolioHoldings();
  }

  @override
  Future<Map<String, dynamic>> getPortfolioPerformance(String timeframe) async {
    return await _apiService.getPortfolioPerformance(timeframe);
  }

  @override
  Future<Map<String, dynamic>> addTransaction(Map<String, dynamic> transaction) async {
    return await _apiService.addTransaction(transaction);
  }
}
