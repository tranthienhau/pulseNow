import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Widget to display WebSocket connection status
class WebSocketIndicator extends StatelessWidget {
  final bool isConnected;

  const WebSocketIndicator({
    super.key,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    if (!isConnected) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark 
        ? Colors.green.shade900.withValues(alpha: 0.3) 
        : Colors.green.shade600;
    const textColor = Colors.white;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            l10n.live,
            style: const TextStyle(
              fontSize: 11,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
