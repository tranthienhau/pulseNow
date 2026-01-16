import 'package:flutter/services.dart';

/// Input validators for form fields
class InputValidators {
  // Private constructor to prevent instantiation
  InputValidators._();

  /// Validates symbol search input
  /// Allows alphanumeric characters, forward slash, dash, and spaces
  static String? validateSymbol(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Empty is allowed for search
    }

    // Check length
    if (value.length > 20) {
      return 'Symbol must be 20 characters or less';
    }

    // Check for valid characters (alphanumeric, /, -, space)
    final regex = RegExp(r'^[a-zA-Z0-9/\s-]+$');
    if (!regex.hasMatch(value)) {
      return 'Symbol can only contain letters, numbers, /, -, and spaces';
    }

    return null; // Valid
  }

  /// Input formatter for symbol search
  /// Only allows alphanumeric, forward slash, dash, and spaces
  static TextInputFormatter symbolFormatter() {
    return FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9/\s-]'));
  }

  /// Input formatter with max length
  static TextInputFormatter maxLengthFormatter(int maxLength) {
    return LengthLimitingTextInputFormatter(maxLength);
  }

  /// Combined formatter for symbol search
  static List<TextInputFormatter> symbolSearchFormatters() {
    return [
      symbolFormatter(),
      maxLengthFormatter(20),
    ];
  }

  /// Sanitize search query (remove extra spaces, trim)
  static String sanitizeSearchQuery(String query) {
    return query.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
}
