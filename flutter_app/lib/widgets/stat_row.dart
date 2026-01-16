import 'package:flutter/material.dart';
import '../utils/app_text_styles.dart';

/// Reusable widget for displaying a statistic row with icon, label, and value
class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: color ?? Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.labelMedium(context),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge(context).copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
