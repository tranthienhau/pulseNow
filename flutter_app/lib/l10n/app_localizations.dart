import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'PulseNow'**
  String get appTitle;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Message shown when no market data is available
  ///
  /// In en, this message translates to:
  /// **'No market data available'**
  String get noMarketDataAvailable;

  /// 24 hours label
  ///
  /// In en, this message translates to:
  /// **'24h'**
  String get hours24;

  /// Error title for no internet connection
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// Error message for no internet connection
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network and try again.'**
  String get noInternetMessage;

  /// Error title for server error
  ///
  /// In en, this message translates to:
  /// **'Server Error'**
  String get serverError;

  /// Error message for server error
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverErrorMessage;

  /// Error title for connection timeout
  ///
  /// In en, this message translates to:
  /// **'Connection Timeout'**
  String get connectionTimeout;

  /// Error message for connection timeout
  ///
  /// In en, this message translates to:
  /// **'Request timeout. Please check your connection and try again.'**
  String get timeoutMessage;

  /// Generic error title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred. Please try again.'**
  String get unexpectedError;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort by:'**
  String get sortBy;

  /// Sort by symbol option
  ///
  /// In en, this message translates to:
  /// **'Symbol'**
  String get sortBySymbol;

  /// Sort by price option
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get sortByPrice;

  /// Sort by change option
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get sortByChange;

  /// Ascending sort direction
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascending;

  /// Descending sort direction
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descending;

  /// Search field hint text
  ///
  /// In en, this message translates to:
  /// **'Search by symbol (e.g., BTC/USD)'**
  String get searchMarketData;

  /// Message shown when no search results are found
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// Showing filtered results count
  ///
  /// In en, this message translates to:
  /// **'Showing {count} of {total}'**
  String showingOf(int count, int total);

  /// Current price label
  ///
  /// In en, this message translates to:
  /// **'Current Price'**
  String get currentPrice;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Market statistics section title
  ///
  /// In en, this message translates to:
  /// **'Market Statistics'**
  String get marketStatistics;

  /// 24 hour volume label
  ///
  /// In en, this message translates to:
  /// **'Volume (24h)'**
  String get volume24h;

  /// Market cap label
  ///
  /// In en, this message translates to:
  /// **'Market Cap'**
  String get marketCap;

  /// 24 hour high label
  ///
  /// In en, this message translates to:
  /// **'24h High'**
  String get high24h;

  /// 24 hour low label
  ///
  /// In en, this message translates to:
  /// **'24h Low'**
  String get low24h;

  /// Last updated label
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get lastUpdated;

  /// Analytics screen title
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// Error message when loading analytics fails
  ///
  /// In en, this message translates to:
  /// **'Error loading analytics'**
  String get errorLoadingAnalytics;

  /// Market overview section title
  ///
  /// In en, this message translates to:
  /// **'Market Overview'**
  String get marketOverview;

  /// Total market cap label
  ///
  /// In en, this message translates to:
  /// **'Total Market Cap'**
  String get totalMarketCap;

  /// Total 24h volume label
  ///
  /// In en, this message translates to:
  /// **'24h Volume'**
  String get totalVolume24h;

  /// Active markets label
  ///
  /// In en, this message translates to:
  /// **'Active Markets'**
  String get activeMarkets;

  /// Market sentiment section title
  ///
  /// In en, this message translates to:
  /// **'Market Sentiment'**
  String get marketSentiment;

  /// Overall sentiment label
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get overallSentiment;

  /// Bullish sentiment label
  ///
  /// In en, this message translates to:
  /// **'Bullish'**
  String get bullish;

  /// Neutral sentiment label
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get neutral;

  /// Bearish sentiment label
  ///
  /// In en, this message translates to:
  /// **'Bearish'**
  String get bearish;

  /// Fear and greed index label
  ///
  /// In en, this message translates to:
  /// **'Fear & Greed Index'**
  String get fearGreedIndex;

  /// Social sentiment label
  ///
  /// In en, this message translates to:
  /// **'Social Sentiment'**
  String get socialSentiment;

  /// Technical analysis label
  ///
  /// In en, this message translates to:
  /// **'Technical Analysis'**
  String get technicalAnalysis;

  /// On-chain metrics label
  ///
  /// In en, this message translates to:
  /// **'On-Chain Metrics'**
  String get onChainMetrics;

  /// Message shown when no analytics data is available
  ///
  /// In en, this message translates to:
  /// **'No analytics data available'**
  String get noAnalyticsDataAvailable;

  /// Load analytics button text
  ///
  /// In en, this message translates to:
  /// **'Load Analytics'**
  String get loadAnalytics;

  /// Portfolio screen title
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolio;

  /// Error message when loading portfolio fails
  ///
  /// In en, this message translates to:
  /// **'Error loading portfolio'**
  String get errorLoadingPortfolio;

  /// Portfolio summary section title
  ///
  /// In en, this message translates to:
  /// **'Portfolio Summary'**
  String get portfolioSummary;

  /// Total value label
  ///
  /// In en, this message translates to:
  /// **'Total Value'**
  String get totalValue;

  /// Total profit and loss label
  ///
  /// In en, this message translates to:
  /// **'Total P&L'**
  String get totalPnL;

  /// Total profit and loss percentage label
  ///
  /// In en, this message translates to:
  /// **'Total P&L %'**
  String get totalPnLPercent;

  /// Holdings section title
  ///
  /// In en, this message translates to:
  /// **'Holdings'**
  String get holdings;

  /// Quantity label
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Message shown when there are no holdings
  ///
  /// In en, this message translates to:
  /// **'No holdings'**
  String get noHoldings;

  /// Message shown when holdings list is empty
  ///
  /// In en, this message translates to:
  /// **'Your portfolio holdings will appear here'**
  String get portfolioHoldingsAppearHere;

  /// Message shown when no portfolio data is available
  ///
  /// In en, this message translates to:
  /// **'No portfolio data available'**
  String get noPortfolioDataAvailable;

  /// Load portfolio button text
  ///
  /// In en, this message translates to:
  /// **'Load Portfolio'**
  String get loadPortfolio;

  /// Market data screen title
  ///
  /// In en, this message translates to:
  /// **'Market Data'**
  String get marketData;

  /// Tooltip for switching to light mode
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get switchToLightMode;

  /// Tooltip for switching to dark mode
  ///
  /// In en, this message translates to:
  /// **'Switch to dark mode'**
  String get switchToDarkMode;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// Spanish language name
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// Offline mode indicator message
  ///
  /// In en, this message translates to:
  /// **'Offline mode - Showing cached data'**
  String get offlineModeShowingCachedData;

  /// Updated label
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// Time indicator for just now
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Time indicator for minutes ago
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutesAgo(int count);

  /// Time indicator for hours ago
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hoursAgo(int count);

  /// Time indicator for days ago
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String daysAgo(int count);

  /// Page not found error message
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'Unknown error'**
  String get unknownError;

  /// Go home button text
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// Market data not found message
  ///
  /// In en, this message translates to:
  /// **'Market data not found'**
  String get marketDataNotFound;

  /// Unknown label
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Live indicator text
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get live;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
