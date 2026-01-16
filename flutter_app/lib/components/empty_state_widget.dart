import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Widget to display empty state
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRefresh;
  final IconData icon;

  const EmptyStateWidget({
    super.key,
    required this.message,
    required this.onRefresh,
    this.icon = Icons.inbox_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              size: 64, 
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.grey.shade400 
                  : Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 16, 
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey.shade400 
                    : Colors.grey,
              ),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRefresh,
            child: Text(l10n.refresh),
          ),
        ],
      ),
    );
  }
}
