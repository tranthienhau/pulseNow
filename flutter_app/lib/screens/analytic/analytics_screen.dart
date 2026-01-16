import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../providers/analytic/analytics_provider.dart';
import '../../utils/app_text_styles.dart';
import '../../l10n/app_localizations.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    // Load analytics data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final provider = Provider.of<AnalyticsProvider>(context, listen: false);
        provider.loadOverview();
        provider.loadSentiment();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Consumer<AnalyticsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.overview == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null && provider.overview == null) {
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
                    l10n.errorLoadingAnalytics,
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
                      provider.loadOverview();
                      provider.loadSentiment();
                    },
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Section
                if (provider.overview != null) ...[
                  Text(
                    l10n.marketOverview,
                    style: AppTextStyles.sectionTitle(context),
                  ),
                  SizedBox(height: 12.h),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          _buildOverviewRow(
                            context,
                            l10n.totalMarketCap,
                            _formatLargeNumber(provider.overview!['totalMarketCap'] as num?),
                            Icons.account_balance,
                          ),
                          const Divider(),
                          _buildOverviewRow(
                            context,
                            l10n.totalVolume24h,
                            _formatLargeNumber(provider.overview!['totalVolume24h'] as num?),
                            Icons.trending_up,
                          ),
                          const Divider(),
                          _buildOverviewRow(
                            context,
                            l10n.activeMarkets,
                            '${provider.overview!['activeMarkets'] ?? 0}',
                            Icons.bar_chart,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],

                // Sentiment Section
                if (provider.sentiment != null) ...[
                  Text(
                    l10n.marketSentiment,
                    style: AppTextStyles.sectionTitle(context),
                  ),
                  SizedBox(height: 12.h),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          if (provider.sentiment!['overall'] != null) ...[
                            _buildSentimentRow(
                              context,
                              l10n.overallSentiment,
                              provider.sentiment!['overall']['score'] as int? ?? 0,
                              provider.sentiment!['overall']['label'] as String? ?? l10n.neutral,
                            ),
                            const Divider(),
                          ],
                          if (provider.sentiment!['indicators'] != null) ...[
                            _buildIndicatorRow(
                              context,
                              l10n.fearGreedIndex,
                              provider.sentiment!['indicators']['fearGreedIndex'] as int? ?? 0,
                            ),
                            const Divider(),
                            _buildIndicatorRow(
                              context,
                              l10n.socialSentiment,
                              provider.sentiment!['indicators']['socialSentiment'] as int? ?? 0,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],

                // Empty State
                if (provider.overview == null && provider.sentiment == null && !provider.isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.analytics_outlined, 
                          size: 64.sp, 
                          color: Theme.of(context).brightness == Brightness.dark 
                              ? Colors.grey.shade400 
                              : Colors.grey,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          l10n.noAnalyticsDataAvailable,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            provider.loadOverview();
                            provider.loadSentiment();
                          },
                          child: Text(l10n.loadAnalytics),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Icon(icon, size: 24.sp, color: Theme.of(context).primaryColor),
          SizedBox(width: 12.w),
          Expanded(
            child:             Text(
              label,
              style: AppTextStyles.bodyLarge(context),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge(context).copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentRow(
    BuildContext context,
    String label,
    int score,
    String labelText,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyLarge(context),
              ),
              Text(
                labelText,
                style: AppTextStyles.bodyLarge(context).copyWith(
                  fontWeight: FontWeight.bold,
                  color: _getSentimentColor(score),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Theme.of(context).brightness == Brightness.dark 
                ? Colors.grey.shade700 
                : Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(_getSentimentColor(score)),
          ),
          SizedBox(height: 4.h),
          Text(
            '$score/100',
            style: AppTextStyles.bodySmall(context),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorRow(
    BuildContext context,
    String label,
    int score,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppTextStyles.body(context),
              ),
              Text(
                '$score/100',
                style: AppTextStyles.body(context).copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          LinearProgressIndicator(
            value: score / 100,
            backgroundColor: Theme.of(context).brightness == Brightness.dark 
                ? Colors.grey.shade700 
                : Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(_getSentimentColor(score)),
          ),
        ],
      ),
    );
  }

  Color _getSentimentColor(int score) {
    if (score >= 70) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  String _formatLargeNumber(num? value) {
    if (value == null) return 'N/A';
    if (value >= 1000000000000) {
      return '\$${(value / 1000000000000).toStringAsFixed(2)}T';
    } else if (value >= 1000000000) {
      return '\$${(value / 1000000000).toStringAsFixed(2)}B';
    } else if (value >= 1000000) {
      return '\$${(value / 1000000).toStringAsFixed(2)}M';
    } else if (value >= 1000) {
      return '\$${(value / 1000).toStringAsFixed(2)}K';
    }
    return '\$${value.toStringAsFixed(2)}';
  }
}
