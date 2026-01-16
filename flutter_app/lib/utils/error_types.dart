import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

enum ErrorType {
  noInternet,
  serverError,
  timeout,
  unknown,
}

/// Exception thrown by API service
class ApiException implements Exception {
  final String message;
  final ErrorType type;

  ApiException(this.message, this.type);

  @override
  String toString() => message;
}

extension ErrorTypeExtension on ErrorType {
  String message(AppLocalizations l10n) {
    switch (this) {
      case ErrorType.noInternet:
        return l10n.noInternetMessage;
      case ErrorType.serverError:
        return l10n.serverErrorMessage;
      case ErrorType.timeout:
        return l10n.timeoutMessage;
      case ErrorType.unknown:
        return l10n.unexpectedError;
    }
  }

  String title(AppLocalizations l10n) {
    switch (this) {
      case ErrorType.noInternet:
        return l10n.noInternetConnection;
      case ErrorType.serverError:
        return l10n.serverError;
      case ErrorType.timeout:
        return l10n.connectionTimeout;
      case ErrorType.unknown:
        return l10n.error;
    }
  }

  IconData get icon {
    switch (this) {
      case ErrorType.noInternet:
        return Icons.wifi_off;
      case ErrorType.serverError:
        return Icons.error_outline;
      case ErrorType.timeout:
        return Icons.timer_off;
      case ErrorType.unknown:
        return Icons.error_outline;
    }
  }
}
