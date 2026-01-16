import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../models/market_data_model.dart';
import '../../providers/market/market_detail_provider.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/price_display.dart';
import '../../widgets/stat_row.dart';
import '../../widgets/section_card.dart';
import '../../utils/constants.dart';
import '../../components/websocket_indicator.dart';
import '../../l10n/app_localizations.dart';

class MarketDetailScreen extends StatelessWidget {
  final MarketData marketData;

  const MarketDetailScreen({
    super.key,
    required this.marketData,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    // Define formatters once
    final priceFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    
    final largeNumberFormatter = NumberFormat.compactCurrency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return ChangeNotifierProvider(
      create: (_) => MarketDetailProvider(
        symbol: marketData.symbol,
        initialData: marketData,
      ),
      child: Consumer<MarketDetailProvider>(
        builder: (context, provider, child) {
          // Use provider's data or fallback to initial data
          final displayData = provider.marketData ?? marketData;

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  Expanded(
                    child: Text(displayData.symbol),
                  ),
                  if (provider.isWebSocketConnected)
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: WebSocketIndicator(
                        isConnected: provider.isWebSocketConnected,
                      ),
                    ),
                ],
              ),
              elevation: 0,
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Card
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.currentPrice,
                            style: AppTextStyles.label(context),
                          ),
                          SizedBox(height: 8.h),
                          PriceDisplay(
                            price: displayData.price,
                            change24h: displayData.change24h,
                            changePercent24h: displayData.changePercent24h,
                            priceFormatter: priceFormatter,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  
                  // Description
                  if (displayData.description != null) ...[
                    SectionCard(
                      title: l10n.about,
                      child: Text(
                        displayData.description!,
                        style: AppTextStyles.body(context),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                  
                  // Market Stats
                  Text(
                    l10n.marketStatistics,
                    style: AppTextStyles.sectionTitle(context),
                  ),
                  SizedBox(height: 12.h),
                  
                  StatRow(
                    label: l10n.volume24h,
                    value: largeNumberFormatter.format(displayData.volume),
                    icon: Icons.trending_up,
                  ),
                  if (displayData.marketCap != null)
                    StatRow(
                      label: l10n.marketCap,
                      value: largeNumberFormatter.format(displayData.marketCap!),
                      icon: Icons.account_balance,
                    ),
                  if (displayData.high24h != null)
                    StatRow(
                      label: l10n.high24h,
                      value: priceFormatter.format(displayData.high24h!),
                      icon: Icons.arrow_upward,
                      color: const Color(AppConstants.positiveColor),
                    ),
                  if (displayData.low24h != null)
                    StatRow(
                      label: l10n.low24h,
                      value: priceFormatter.format(displayData.low24h!),
                      icon: Icons.arrow_downward,
                      color: const Color(AppConstants.negativeColor),
                    ),
                  if (displayData.lastUpdated != null) ...[
                    SizedBox(height: 8.h),
                    Text(
                      '${l10n.lastUpdated}: ${_formatDate(displayData.lastUpdated!)}',
                      style: AppTextStyles.bodySmall(context),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
