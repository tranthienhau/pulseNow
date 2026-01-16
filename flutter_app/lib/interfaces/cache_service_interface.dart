/// Interface for cache service
abstract class ICacheService {
  /// Save market data to cache
  Future<void> saveMarketData(List<Map<String, dynamic>> data);
  
  /// Get market data from cache
  Future<List<Map<String, dynamic>>?> getMarketData();
  
  /// Check if cache exists and is valid
  Future<bool> hasValidCache({Duration? maxAge});
  
  /// Clear cache
  Future<void> clearCache();
  
  /// Get cache timestamp
  Future<DateTime?> getCacheTimestamp();
}
