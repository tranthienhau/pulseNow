import 'package:flutter/material.dart';
import 'sort_option.dart';
import '../services/analytics_tracking_service.dart';
import '../l10n/app_localizations.dart';

/// Reusable sort control widget with dropdown and direction toggle
class SortControl extends StatelessWidget {
  final SortOption value;
  final bool ascending;
  final ValueChanged<SortOption> onSortChanged;
  final VoidCallback onDirectionChanged;

  const SortControl({
    super.key,
    required this.value,
    required this.ascending,
    required this.onSortChanged,
    required this.onDirectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final analytics = AnalyticsTrackingService();
    
    return Row(
      children: [
        Text('${l10n.sortBy} '),
        const SizedBox(width: 8),
        Expanded(
          child: DropdownButton<SortOption>(
            value: value,
            isExpanded: true,
            items: [
              DropdownMenuItem(
                value: SortOption.symbol,
                child: Text(l10n.sortBySymbol),
              ),
              DropdownMenuItem(
                value: SortOption.price,
                child: Text(l10n.sortByPrice),
              ),
              DropdownMenuItem(
                value: SortOption.change,
                child: Text(l10n.sortByChange),
              ),
            ],
            onChanged: (SortOption? newValue) {
              if (newValue != null) {
                analytics.trackSort(
                  newValue.toString().split('.').last,
                  ascending: ascending,
                );
                onSortChanged(newValue);
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Icon(
            ascending ? Icons.arrow_upward : Icons.arrow_downward,
          ),
          onPressed: () {
            analytics.trackSort(
              value.toString().split('.').last,
              ascending: !ascending,
            );
            onDirectionChanged();
          },
          tooltip: ascending ? l10n.ascending : l10n.descending,
        ),
      ],
    );
  }
}
