import 'package:flutter/material.dart';

/// Reusable text styles for the app
class AppTextStyles {
  // Private constructor to prevent instantiation
  AppTextStyles._();

  // Symbol/Title Styles
  static TextStyle symbolTitle(BuildContext context) {
    return const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle symbolTitleLarge(BuildContext context) {
    return const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );
  }

  // Price Styles
  static TextStyle price(BuildContext context) {
    return const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle priceLarge(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ) ?? const TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle priceSmall(BuildContext context) {
    return const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );
  }

  // Change/Percentage Styles
  static TextStyle changePercent(BuildContext context, {required Color color}) {
    return TextStyle(
      color: color,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle changePercentLarge(BuildContext context, {required Color color}) {
    return TextStyle(
      color: color,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle changeAmount(BuildContext context, {required Color color}) {
    return TextStyle(
      color: color,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle changeAmountMedium(BuildContext context, {required Color color}) {
    return TextStyle(
      color: color,
      fontSize: 16,
    );
  }

  // Label Styles
  static TextStyle label(BuildContext context) {
    return Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Colors.grey[600],
        ) ?? TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return TextStyle(
      color: Colors.grey[600],
      fontSize: 12,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium ?? const TextStyle(
      fontSize: 14,
    );
  }

  // Body Styles
  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium ?? const TextStyle(
      fontSize: 14,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey[600],
        ) ?? TextStyle(
      fontSize: 12,
      color: Colors.grey[600],
    );
  }

  // Section Title
  static TextStyle sectionTitle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ) ?? const TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
  }
}
