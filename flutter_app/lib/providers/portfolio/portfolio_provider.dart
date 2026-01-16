import 'package:flutter/foundation.dart';
import '../../interfaces/api_service_interface.dart';
import '../../services/api_service.dart';
import '../../services/service_locator.dart';
import '../../utils/error_types.dart';

class PortfolioProvider with ChangeNotifier {
  final IApiService _apiService = getIt<IApiService>();
  
  Map<String, dynamic>? _summary;
  List<Map<String, dynamic>> _holdings = [];
  Map<String, dynamic>? _performance;
  bool _isLoading = false;
  String? _error;
  ErrorType? _errorType;
  
  Map<String, dynamic>? get summary => _summary;
  List<Map<String, dynamic>> get holdings => _holdings;
  Map<String, dynamic>? get performance => _performance;
  bool get isLoading => _isLoading;
  String? get error => _error;
  ErrorType? get errorType => _errorType;
  
  /// Load portfolio summary
  Future<void> loadPortfolioSummary() async {
    _isLoading = true;
    _error = null;
    _errorType = null;
    notifyListeners();
    
    try {
      final data = await _apiService.getPortfolioSummary();
      _summary = data;
      _error = null;
      _errorType = null;
    } on ApiException catch (e) {
      _error = e.message;
      _errorType = e.type;
    } catch (e) {
      _error = e.toString();
      _errorType = ErrorType.unknown;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load portfolio holdings
  Future<void> loadHoldings() async {
    _isLoading = true;
    _error = null;
    _errorType = null;
    notifyListeners();
    
    try {
      final data = await _apiService.getPortfolioHoldings();
      _holdings = data;
      _error = null;
      _errorType = null;
    } on ApiException catch (e) {
      _error = e.message;
      _errorType = e.type;
    } catch (e) {
      _error = e.toString();
      _errorType = ErrorType.unknown;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Load portfolio performance for a specific timeframe
  Future<void> loadPerformance(String timeframe) async {
    _isLoading = true;
    _error = null;
    _errorType = null;
    notifyListeners();
    
    try {
      final data = await _apiService.getPortfolioPerformance(timeframe);
      _performance = data;
      _error = null;
      _errorType = null;
    } on ApiException catch (e) {
      _error = e.message;
      _errorType = e.type;
    } catch (e) {
      _error = e.toString();
      _errorType = ErrorType.unknown;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Add a transaction to the portfolio
  Future<bool> addTransaction(Map<String, dynamic> transaction) async {
    _isLoading = true;
    _error = null;
    _errorType = null;
    notifyListeners();
    
    try {
      await _apiService.addTransaction(transaction);
      _error = null;
      _errorType = null;
      
      // Reload holdings and summary after adding transaction
      await Future.wait([
        loadHoldings(),
        loadPortfolioSummary(),
      ]);
      
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      _errorType = e.type;
      return false;
    } catch (e) {
      _error = e.toString();
      _errorType = ErrorType.unknown;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
