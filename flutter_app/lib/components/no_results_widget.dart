import 'package:flutter/material.dart';

/// Widget to display when no search results are found
class NoResultsWidget extends StatelessWidget {
  final String message;

  const NoResultsWidget({
    super.key,
    this.message = 'No results found',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off, 
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
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}
