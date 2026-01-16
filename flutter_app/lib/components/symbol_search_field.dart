import 'package:flutter/material.dart';
import '../utils/input_validators.dart';
import '../services/analytics_tracking_service.dart';
import '../l10n/app_localizations.dart';

/// Reusable search field for symbol search with validation
class SymbolSearchField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onSearch;

  const SymbolSearchField({
    super.key,
    required this.controller,
    this.onSearch,
  });

  @override
  State<SymbolSearchField> createState() => _SymbolSearchFieldState();
}

class _SymbolSearchFieldState extends State<SymbolSearchField> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AnalyticsTrackingService _analytics = AnalyticsTrackingService();
  String? _searchError;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            inputFormatters: InputValidators.symbolSearchFormatters(),
            decoration: InputDecoration(
              hintText: l10n.searchMarketData,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          widget.controller.clear();
                          _searchError = null;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              errorText: _searchError,
              errorMaxLines: 2,
            ),
            validator: InputValidators.validateSymbol,
            onChanged: (value) {
              setState(() {
                // Clear error on valid input
                final validationError = InputValidators.validateSymbol(value);
                _searchError = validationError;
                
                // Track search if valid
                if (value.isNotEmpty && validationError == null) {
                  _analytics.trackSearch(value);
                  widget.onSearch?.call(value);
                }
              });
            },
            onFieldSubmitted: (value) {
              // Validate on submit
              if (_formKey.currentState?.validate() ?? false) {
                _analytics.trackSearch(value);
                widget.onSearch?.call(value);
              }
            },
          ),
          if (_searchError != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, left: 12.0),
              child: Text(
                _searchError!,
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
