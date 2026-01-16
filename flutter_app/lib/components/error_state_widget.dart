import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../utils/error_types.dart';

/// Widget to display error state
class ErrorStateWidget extends StatelessWidget {
  final String? error;
  final ErrorType errorType;
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.error,
    required this.errorType,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              errorType.icon,
              size: 64,
              color: errorType == ErrorType.noInternet 
                  ? Colors.orange 
                  : Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              errorType.title(l10n),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorType.message(l10n),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark 
                    ? Colors.grey.shade400 
                    : Colors.grey.shade600,
              ),
            ),
            if (error != null && error != errorType.message(l10n)) ...[
              const SizedBox(height: 8),
              Text(
                error!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.grey.shade500 
                      : Colors.grey.shade500,
                ),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
