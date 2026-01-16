import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/market/market_data_provider.dart';
import '../../utils/error_types.dart';
import '../../utils/input_validators.dart';
import '../../models/market_data_model.dart';
import '../../widgets/market_data_item.dart';
import '../../services/analytics_tracking_service.dart';
import '../../components/sort_option.dart';
import '../../components/offline_indicator.dart';
import '../../components/symbol_search_field.dart';
import '../../components/sort_control.dart';
import '../../components/error_state_widget.dart';
import '../../components/empty_state_widget.dart';
import '../../components/no_results_widget.dart';
import '../../components/websocket_indicator.dart';

class MarketDataScreen extends StatefulWidget {
  const MarketDataScreen({super.key});

  @override
  State<MarketDataScreen> createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AnalyticsTrackingService _analytics = AnalyticsTrackingService();
  SortOption _sortOption = SortOption.symbol;
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    // Track screen view
    _analytics.trackScreenView('market_data');
    
    // Load market data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        Provider.of<MarketDataProvider>(context, listen: false).loadMarketData();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MarketData> _getFilteredAndSortedData(List<MarketData> data) {
    // Filter by search query
    final query = InputValidators.sanitizeSearchQuery(_searchController.text);
    if (query.isEmpty) {
      // No filter if search is empty
      var sorted = List<MarketData>.from(data);
      sorted.sort((a, b) {
        int comparison = 0;
        switch (_sortOption) {
          case SortOption.symbol:
            comparison = a.symbol.compareTo(b.symbol);
            break;
          case SortOption.price:
            comparison = a.price.compareTo(b.price);
            break;
          case SortOption.change:
            comparison = a.change24h.compareTo(b.change24h);
            break;
        }
        return _sortAscending ? comparison : -comparison;
      });
      return sorted;
    }
    
    var filtered = data.where((item) {
      return item.symbol.toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Sort
    filtered.sort((a, b) {
      int comparison = 0;
      switch (_sortOption) {
        case SortOption.symbol:
          comparison = a.symbol.compareTo(b.symbol);
          break;
        case SortOption.price:
          comparison = a.price.compareTo(b.price);
          break;
        case SortOption.change:
          comparison = a.change24h.compareTo(b.change24h);
          break;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<MarketDataProvider>(
      builder: (context, provider, child) {
        // Show loading indicator when provider.isLoading is true
        if (provider.isLoading && provider.marketData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        // Show error message when provider.error is not null
        if (provider.error != null && provider.marketData.isEmpty) {
          final errorType = provider.errorType ?? ErrorType.unknown;
          return ErrorStateWidget(
            error: provider.error,
            errorType: errorType,
            onRetry: () => provider.loadMarketData(),
          );
        }
        
        // Show empty state when no data is available
        if (provider.marketData.isEmpty) {
          return EmptyStateWidget(
            message: l10n.noMarketDataAvailable,
            onRefresh: () => provider.loadMarketData(),
          );
        }

        final filteredData = _getFilteredAndSortedData(provider.marketData);
        
        // Show list of market data
        return Column(
          children: [
            // Status Indicators
            if (provider.isOffline)
              OfflineIndicator(
                lastUpdated: provider.lastUpdated,
              ),
            // WebSocket Connection Indicator
            if (provider.isWebSocketConnected)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    WebSocketIndicator(
                      isConnected: provider.isWebSocketConnected,
                    ),
                  ],
                ),
              ),
            // Search and Sort Bar
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  // Search Bar with Validation
                  SymbolSearchField(
                    controller: _searchController,
                  ),
                  SizedBox(height: 12.h),
                  // Sort Options
                  SortControl(
                    value: _sortOption,
                    ascending: _sortAscending,
                    onSortChanged: (newValue) {
                      setState(() {
                        _sortOption = newValue;
                      });
                    },
                    onDirectionChanged: () {
                      setState(() {
                        _sortAscending = !_sortAscending;
                      });
                    },
                  ),
                  if (filteredData.length != provider.marketData.length)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        l10n.showingOf(filteredData.length, provider.marketData.length),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              ),
            ),
            // Market Data List
            Expanded(
              child: filteredData.isEmpty
                  ? NoResultsWidget(
                      message: l10n.noResultsFound,
                    )
                  : RefreshIndicator(
                      onRefresh: () {
                        _analytics.trackEvent('pull_to_refresh');
                        return provider.loadMarketData();
                      },
                      child: ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          return MarketDataItem(
                            marketData: filteredData[index],
                            l10n: l10n,
                          );
                        },
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}
