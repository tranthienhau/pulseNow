import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/market/market_data_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/analytic/analytics_provider.dart';
import 'providers/portfolio/portfolio_provider.dart';
import 'providers/theme_provider.dart';
import 'routes/app_router.dart';
import 'services/service_locator.dart';

void main() {
  // Initialize dependency injection
  setupServiceLocator();
  
  runApp(const PulseNowApp());
}

class PulseNowApp extends StatelessWidget {
  const PulseNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MarketDataProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return ScreenUtilInit(
            designSize: const Size(375, 812), // iPhone X design size
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                title: 'PulseNow',
                theme: _buildLightTheme(),
                darkTheme: _buildDarkTheme(),
                themeMode: themeProvider.themeMode,
                // Localization support
                locale: localeProvider.locale,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'), // English
                  Locale('es'), // Spanish
                ],
                routerConfig: AppRouter.getRouter(context),
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }

  /// Build light theme
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  /// Build dark theme
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
    );
  }
}
