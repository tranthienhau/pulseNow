import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../providers/theme_provider.dart';
import 'market/market_data_screen.dart';
import 'analytic/analytics_screen.dart';
import 'portfolio/portfolio_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MarketDataScreen(),
    const AnalyticsScreen(),
    const PortfolioScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(_currentIndex, l10n)),
        elevation: 0,
        actions: [
          // Theme toggle button
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode 
                      ? Icons.light_mode 
                      : Icons.dark_mode,
                ),
                onPressed: () {
                  themeProvider.toggleTheme();
                },
                tooltip: themeProvider.isDarkMode 
                    ? l10n.switchToLightMode 
                    : l10n.switchToDarkMode,
              );
            },
          ),
          // Language selector dropdown
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String localeCode) {
              localeProvider.setLocaleFromString(localeCode);
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'en',
                child: Row(
                  children: [
                    Text(l10n.english),
                    if (localeProvider.locale.languageCode == 'en')
                      Icon(Icons.check, size: 16.sp),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'es',
                child: Row(
                  children: [
                    Text(l10n.spanish),
                    if (localeProvider.locale.languageCode == 'es')
                      Icon(Icons.check, size: 16.sp),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.trending_up),
            label: l10n.marketData,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics),
            label: l10n.analytics,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet),
            label: l10n.portfolio,
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle(int index, AppLocalizations l10n) {
    switch (index) {
      case 0:
        return l10n.appTitle;
      case 1:
        return l10n.analytics;
      case 2:
        return l10n.portfolio;
      default:
        return l10n.appTitle;
    }
  }
}
