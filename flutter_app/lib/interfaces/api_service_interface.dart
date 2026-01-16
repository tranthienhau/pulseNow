/// Interface for API service
abstract class IApiService {
  /// Fetches market data from the API
  /// 
  /// Returns a list of market data as Map<String, dynamic>
  /// Throws [ApiException] if the request fails
  Future<List<Map<String, dynamic>>> getMarketData();
  
  /// Fetches analytics overview from the API
  /// 
  /// Returns analytics overview data as Map<String, dynamic>
  /// Throws [ApiException] if the request fails
  Future<Map<String, dynamic>> getAnalyticsOverview();
  
  /// Fetches market trends from the API
  /// 
  /// [timeframe] - The timeframe for trends (e.g., '24h', '7d', '30d')
  /// Returns trends data as Map<String, dynamic>
  /// Throws [ApiException] if the request fails
  Future<Map<String, dynamic>> getAnalyticsTrends(String timeframe);
  
  /// Fetches market sentiment from the API
  /// 
  /// Returns sentiment data as Map<String, dynamic>
  /// Throws [ApiException] if the request fails
  Future<Map<String, dynamic>> getAnalyticsSentiment();
  
  /// Fetches portfolio summary from the API
  /// 
  /// Returns portfolio summary data as Map<String, dynamic>
  /// Throws [ApiException] if the request fails
  Future<Map<String, dynamic>> getPortfolioSummary();
  
  /// Fetches portfolio holdings from the API
  /// 
  /// Returns portfolio holdings as List<Map<String, dynamic>>
  /// Throws [ApiException] if the request fails
  Future<List<Map<String, dynamic>>> getPortfolioHoldings();
  
  /// Fetches portfolio performance from the API
  /// 
  /// [timeframe] - The timeframe for performance (e.g., '7d', '30d', '90d')
  /// Returns performance data as Map<String, dynamic>
  /// Throws [ApiException] if the request fails
  Future<Map<String, dynamic>> getPortfolioPerformance(String timeframe);
  
  /// Adds a transaction to the portfolio
  /// 
  /// [transaction] - Transaction data as Map<String, dynamic>
  /// Returns the created transaction as Map<String, dynamic>
  /// Throws [ApiException] if the request fails
  Future<Map<String, dynamic>> addTransaction(Map<String, dynamic> transaction);
}
