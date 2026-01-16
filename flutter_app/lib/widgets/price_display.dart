import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_text_styles.dart';
import '../utils/constants.dart';

/// Reusable widget for displaying price with change indicator
class PriceDisplay extends StatelessWidget {
  final double price;
  final double change24h;
  final double changePercent24h;
  final NumberFormat? priceFormatter;
  final bool showChange;

  const PriceDisplay({
    super.key,
    required this.price,
    required this.change24h,
    required this.changePercent24h,
    this.priceFormatter,
    this.showChange = true,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change24h >= 0;
    final changeColor = isPositive 
        ? const Color(AppConstants.positiveColor) 
        : const Color(AppConstants.negativeColor);
    
    final formatter = priceFormatter ?? NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );
    
    final percentFormatter = NumberFormat.decimalPercentPattern(
      decimalDigits: 2,
    );
    final changePercent = changePercent24h / 100;
    final changePercentText = isPositive 
        ? '+${percentFormatter.format(changePercent)}'
        : percentFormatter.format(changePercent);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          formatter.format(price),
          style: AppTextStyles.priceLarge(context),
        ),
        if (showChange) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                color: changeColor,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                changePercentText,
                style: AppTextStyles.changePercentLarge(context, color: changeColor),
              ),
              const SizedBox(width: 8),
              Text(
                '(${formatter.format(change24h.abs())})',
                style: AppTextStyles.changeAmountMedium(context, color: changeColor),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
