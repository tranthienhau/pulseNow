// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PulseNow';

  @override
  String get retry => 'Retry';

  @override
  String get refresh => 'Refresh';

  @override
  String get noMarketDataAvailable => 'No market data available';

  @override
  String get hours24 => '24h';

  @override
  String get noInternetConnection => 'No Internet Connection';

  @override
  String get noInternetMessage =>
      'No internet connection. Please check your network and try again.';

  @override
  String get serverError => 'Server Error';

  @override
  String get serverErrorMessage => 'Server error. Please try again later.';

  @override
  String get connectionTimeout => 'Connection Timeout';

  @override
  String get timeoutMessage =>
      'Request timeout. Please check your connection and try again.';

  @override
  String get error => 'Error';

  @override
  String get unexpectedError =>
      'An unexpected error occurred. Please try again.';

  @override
  String get sortBy => 'Sort by:';

  @override
  String get sortBySymbol => 'Symbol';

  @override
  String get sortByPrice => 'Price';

  @override
  String get sortByChange => 'Change';

  @override
  String get ascending => 'Ascending';

  @override
  String get descending => 'Descending';

  @override
  String get searchMarketData => 'Search by symbol (e.g., BTC/USD)';

  @override
  String get noResultsFound => 'No results found';

  @override
  String showingOf(int count, int total) {
    return 'Showing $count of $total';
  }

  @override
  String get currentPrice => 'Current Price';

  @override
  String get description => 'Description';

  @override
  String get about => 'About';

  @override
  String get marketStatistics => 'Market Statistics';

  @override
  String get volume24h => 'Volume (24h)';

  @override
  String get marketCap => 'Market Cap';

  @override
  String get high24h => '24h High';

  @override
  String get low24h => '24h Low';

  @override
  String get lastUpdated => 'Last updated';

  @override
  String get analytics => 'Analytics';

  @override
  String get errorLoadingAnalytics => 'Error loading analytics';

  @override
  String get marketOverview => 'Market Overview';

  @override
  String get totalMarketCap => 'Total Market Cap';

  @override
  String get totalVolume24h => '24h Volume';

  @override
  String get activeMarkets => 'Active Markets';

  @override
  String get marketSentiment => 'Market Sentiment';

  @override
  String get overallSentiment => 'Overall';

  @override
  String get bullish => 'Bullish';

  @override
  String get neutral => 'Neutral';

  @override
  String get bearish => 'Bearish';

  @override
  String get fearGreedIndex => 'Fear & Greed Index';

  @override
  String get socialSentiment => 'Social Sentiment';

  @override
  String get technicalAnalysis => 'Technical Analysis';

  @override
  String get onChainMetrics => 'On-Chain Metrics';

  @override
  String get noAnalyticsDataAvailable => 'No analytics data available';

  @override
  String get loadAnalytics => 'Load Analytics';

  @override
  String get portfolio => 'Portfolio';

  @override
  String get errorLoadingPortfolio => 'Error loading portfolio';

  @override
  String get portfolioSummary => 'Portfolio Summary';

  @override
  String get totalValue => 'Total Value';

  @override
  String get totalPnL => 'Total P&L';

  @override
  String get totalPnLPercent => 'Total P&L %';

  @override
  String get holdings => 'Holdings';

  @override
  String get quantity => 'Quantity';

  @override
  String get noHoldings => 'No holdings';

  @override
  String get portfolioHoldingsAppearHere =>
      'Your portfolio holdings will appear here';

  @override
  String get noPortfolioDataAvailable => 'No portfolio data available';

  @override
  String get loadPortfolio => 'Load Portfolio';

  @override
  String get marketData => 'Market Data';

  @override
  String get switchToLightMode => 'Switch to light mode';

  @override
  String get switchToDarkMode => 'Switch to dark mode';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Español';

  @override
  String get offlineModeShowingCachedData =>
      'Offline mode - Showing cached data';

  @override
  String get updated => 'Updated';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    return '${count}m ago';
  }

  @override
  String hoursAgo(int count) {
    return '${count}h ago';
  }

  @override
  String daysAgo(int count) {
    return '${count}d ago';
  }

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get goHome => 'Go Home';

  @override
  String get marketDataNotFound => 'Market data not found';

  @override
  String get unknown => 'Unknown';

  @override
  String get live => 'Live';
}
