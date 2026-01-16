import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Widget to display offline mode indicator
class OfflineIndicator extends StatelessWidget {
  final DateTime? lastUpdated;

  const OfflineIndicator({
    super.key,
    this.lastUpdated,
  });

  String _formatLastUpdated(DateTime dateTime, AppLocalizations l10n) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inMinutes < 1) {
      return l10n.justNow;
    } else if (difference.inMinutes < 60) {
      return l10n.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.hoursAgo(difference.inHours);
    } else {
      return l10n.daysAgo(difference.inDays);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final orangeColor = isDark ? Colors.orange.shade900 : Colors.orange.shade800;
    final backgroundColor = isDark ? Colors.orange.shade900.withValues(alpha: 0.3) : Colors.orange.shade100;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: backgroundColor,
      child: Row(
        children: [
          Icon(Icons.cloud_off, size: 16, color: orangeColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.offlineModeShowingCachedData,
              style: TextStyle(
                fontSize: 12,
                color: orangeColor,
              ),
            ),
          ),
          if (lastUpdated != null)
            Text(
              '${l10n.updated}: ${_formatLastUpdated(lastUpdated!, l10n)}',
              style: TextStyle(
                fontSize: 11,
                color: orangeColor.withValues(alpha: 0.8),
              ),
            ),
        ],
      ),
    );
  }
}
