import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/market_data_model.dart';
import '../routes/app_router.dart';
import '../utils/app_text_styles.dart';
import '../utils/constants.dart';
import '../l10n/app_localizations.dart';
import '../services/analytics_tracking_service.dart';

/// Reusable widget for displaying market data in a list
class MarketDataItem extends StatelessWidget {
  final MarketData marketData;
  final AppLocalizations l10n;
  static final AnalyticsTrackingService _analytics = AnalyticsTrackingService();

  const MarketDataItem({
    super.key,
    required this.marketData,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = marketData.change24h >= 0;
    final changeColor = isPositive 
        ? const Color(AppConstants.positiveColor) 
        : const Color(AppConstants.negativeColor);
    
    final priceFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    
    final percentFormatter = NumberFormat.decimalPercentPattern(
      decimalDigits: 2,
    );
    final changePercent = marketData.changePercent24h / 100;
    final changePercentText = isPositive 
        ? '+${percentFormatter.format(changePercent)}'
        : percentFormatter.format(changePercent);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        onTap: () {
          _analytics.trackMarketDataInteraction(
            'view_detail',
            symbol: marketData.symbol,
          );
          _analytics.trackNavigation('market_data_list', 'market_detail', parameters: {
            'symbol': marketData.symbol,
          });
          AppRouter.goToMarketDetail(context, marketData);
        },
        title: Text(
          marketData.symbol,
          style: AppTextStyles.symbolTitle(context),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Text(
                changePercentText,
                style: AppTextStyles.changePercent(context, color: changeColor),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.hours24,
                style: AppTextStyles.labelSmall(context),
              ),
            ],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              priceFormatter.format(marketData.price),
              style: AppTextStyles.price(context),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: changeColor,
                ),
                const SizedBox(width: 4),
                Text(
                  priceFormatter.format(marketData.change24h.abs()),
                  style: AppTextStyles.changeAmount(context, color: changeColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
