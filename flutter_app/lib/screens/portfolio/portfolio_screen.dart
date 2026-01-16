import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/portfolio/portfolio_provider.dart';
import '../../utils/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  void initState() {
    super.initState();
    // Load portfolio data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = Provider.of<PortfolioProvider>(context, listen: false);
        provider.loadPortfolioSummary();
        provider.loadHoldings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Consumer<PortfolioProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.summary == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.summary == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline, 
                    size: 64, 
                    color: Colors.red,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.errorLoadingPortfolio,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    provider.error!,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () {
                      provider.loadPortfolioSummary();
                      provider.loadHoldings();
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadPortfolioSummary();
              await provider.loadHoldings();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Portfolio Summary
                if (provider.summary != null) ...[
                  Text(
                    l10n.portfolioSummary,
                    style: AppTextStyles.sectionTitle(context),
                  ),
                  SizedBox(height: 12.h),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            context,
                            l10n.totalValue,
                            _formatCurrency(_parseNumber(provider.summary!['totalValue'])),
                            Icons.account_balance_wallet,
                          ),
                          const Divider(),
                          _buildSummaryRow(
                            context,
                            l10n.totalPnL,
                            _formatCurrency(_parseNumber(provider.summary!['totalPnL'])),
                            Icons.trending_up,
                            color: _getPnLColor(_parseNumber(provider.summary!['totalPnL'])),
                          ),
                          const Divider(),
                          _buildSummaryRow(
                            context,
                            l10n.totalPnLPercent,
                            _formatPercentage(_parseNumber(provider.summary!['totalPnLPercent'])),
                            Icons.percent,
                            color: _getPnLColor(_parseNumber(provider.summary!['totalPnL'])),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                // Holdings Section
                Text(
                  l10n.holdings,
                  style: AppTextStyles.sectionTitle(context),
                  ),
                SizedBox(height: 12.h),
                if (provider.holdings.isNotEmpty) ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: provider.holdings.length,
                    itemBuilder: (context, index) {
                      final holding = provider.holdings[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 8.h),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              ((holding['symbol'] as String?) ?? '?')[0],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            (holding['symbol'] as String?) ?? l10n.unknown,
                            style: AppTextStyles.symbolTitle(context),
                          ),
                          subtitle: Text(
                            '${l10n.quantity}: ${_parseNumber(holding['quantity']) ?? 0}',
                            style: AppTextStyles.bodySmall(context),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _formatCurrency(_parseNumber(holding['value'])),
                                style: AppTextStyles.price(context),
                              ),
                              if (holding['pnl'] != null)
                                Text(
                                  _formatCurrency(_parseNumber(holding['pnl'])),
                                  style: AppTextStyles.changeAmount(
                                    context,
                                    color: _getPnLColor(_parseNumber(holding['pnl'])),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ] else ...[
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox_outlined, 
                              size: 64.sp, 
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Colors.grey.shade400 
                                  : Colors.grey,
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              l10n.noHoldings,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              l10n.portfolioHoldingsAppearHere,
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],

                // Empty State
                if (provider.summary == null && !provider.isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_outlined, 
                          size: 64.sp, 
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.grey.shade400 
                              : Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          l10n.noPortfolioDataAvailable,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            provider.loadPortfolioSummary();
                            provider.loadHoldings();
                          },
                          child: Text(l10n.loadPortfolio),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 24.sp, color: color ?? Theme.of(context).primaryColor),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyLarge(context),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge(context).copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Parse a value that could be a String or num to num?
  num? _parseNumber(dynamic value) {
    if (value == null) return null;
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(value);
    }
    return null;
  }

  Color _getPnLColor(num? value) {
    if (value == null) {
      return Theme.of(context).brightness == Brightness.dark 
          ? Colors.grey.shade400 
          : Colors.grey;
    }
    if (value > 0) return Colors.green;
    if (value < 0) return Colors.red;
    return Theme.of(context).brightness == Brightness.dark 
        ? Colors.grey.shade400 
        : Colors.grey;
  }

  String _formatCurrency(num? value) {
    if (value == null) return '\$0.00';
    return '\$${value.toStringAsFixed(2)}';
  }

  String _formatPercentage(num? value) {
    if (value == null) return '0.00%';
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }
}
