import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/home_screen.dart';
import '../screens/market/market_data_screen.dart';
import '../screens/market/market_detail_screen.dart';
import '../models/market_data_model.dart';
import '../l10n/app_localizations.dart';

/// App router configuration using go_router
class AppRouter {
  // Route paths
  static const String home = '/';
  static const String marketData = '/market-data';
  static const String marketDetail = '/market-detail/:symbol';
  
  // Route names
  static const String homeName = 'home';
  static const String marketDataName = 'market-data';
  static const String marketDetailName = 'market-detail';
  
  /// Get the router instance
  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      initialLocation: home,
      routes: [
        GoRoute(
          path: home,
          name: homeName,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: marketData,
          name: marketDataName,
          builder: (context, state) => const MarketDataScreen(),
        ),
        GoRoute(
          path: marketDetail,
          name: marketDetailName,
          builder: (context, state) {
            final symbol = state.pathParameters['symbol'] ?? '';
            final marketData = state.extra as MarketData?;
            if (marketData != null) {
              return MarketDetailScreen(marketData: marketData);
            }
            // Fallback - you might want to fetch data by symbol here
            final l10n = AppLocalizations.of(context);
            return Scaffold(
              appBar: AppBar(title: Text(symbol)),
              body: Center(
                child: Text(l10n?.marketDataNotFound ?? 'Market data not found'),
              ),
            );
          },
        ),
      ],
      errorBuilder: (context, state) {
        final l10n = AppLocalizations.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n?.error ?? 'Error'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline, 
                  size: 64, 
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n?.pageNotFound ?? 'Page not found',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  state.error?.toString() ?? (l10n?.unknownError ?? 'Unknown error'),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go(home),
                  child: Text(l10n?.goHome ?? 'Go Home'),
                ),
              ],
            ),
          ),
        );
      },
      debugLogDiagnostics: true,
    );
  }
  
  /// Navigate to home screen
  static void goHome(BuildContext context) {
    context.go(home);
  }
  
  /// Navigate to market data screen
  static void goToMarketData(BuildContext context) {
    context.go(marketData);
  }
  
  /// Push market data screen
  static void pushMarketData(BuildContext context) {
    context.push(marketData);
  }
  
  /// Navigate to market detail screen
  static void goToMarketDetail(BuildContext context, MarketData marketData) {
    context.push(
      '/market-detail/${Uri.encodeComponent(marketData.symbol)}',
      extra: marketData,
    );
  }
}
