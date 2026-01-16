import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';
import '../utils/error_types.dart';
import '../interfaces/api_service_interface.dart';

// Re-export ApiException for convenience
export '../utils/error_types.dart' show ApiException;

class ApiService implements IApiService {
  static const String baseUrl = AppConstants.baseUrl;
  
  @override
  Future<List<Map<String, dynamic>>> getMarketData() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/market-data'))
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        
        // The API returns { success: true, data: [...] }
        if (jsonData.containsKey('data')) {
          final data = jsonData['data'];
          if (data is List) {
            return List<Map<String, dynamic>>.from(data);
          } else {
            throw ApiException('Unexpected data format: expected array', ErrorType.unknown);
          }
        } else {
          throw ApiException('Unexpected response format: missing data field', ErrorType.unknown);
        }
      } else {
        throw ApiException(
          'Failed to load market data: ${response.statusCode}',
          ErrorType.serverError,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', ErrorType.noInternet);
    } on HttpException catch (e) {
      throw ApiException('HTTP error: ${e.message}', ErrorType.serverError);
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}', ErrorType.unknown);
    } on http.ClientException {
      throw ApiException('Network error: Unable to connect to server', ErrorType.noInternet);
    } on Exception catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('timeout') || errorString.contains('timed out')) {
        throw ApiException('Request timeout', ErrorType.timeout);
      } else if (errorString.contains('socket') || 
                 errorString.contains('network') ||
                 errorString.contains('connection')) {
        throw ApiException('Network error: ${e.toString()}', ErrorType.noInternet);
      } else {
        throw ApiException('Error: ${e.toString()}', ErrorType.unknown);
      }
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('timeout') || errorString.contains('timed out')) {
        throw ApiException('Request timeout', ErrorType.timeout);
      } else if (errorString.contains('socket') || 
                 errorString.contains('network') ||
                 errorString.contains('connection') ||
                 errorString.contains('failed host lookup')) {
        throw ApiException('No internet connection', ErrorType.noInternet);
      } else {
        throw ApiException('Unexpected error: ${e.toString()}', ErrorType.unknown);
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsOverview() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/analytics/overview'))
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        
        if (jsonData.containsKey('data')) {
          return jsonData['data'] as Map<String, dynamic>;
        } else {
          throw ApiException('Unexpected response format: missing data field', ErrorType.unknown);
        }
      } else {
        throw ApiException(
          'Failed to load analytics overview: ${response.statusCode}',
          ErrorType.serverError,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', ErrorType.noInternet);
    } on HttpException catch (e) {
      throw ApiException('HTTP error: ${e.message}', ErrorType.serverError);
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}', ErrorType.unknown);
    } on http.ClientException {
      throw ApiException('Network error: Unable to connect to server', ErrorType.noInternet);
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('timeout') || errorString.contains('timed out')) {
        throw ApiException('Request timeout', ErrorType.timeout);
      } else if (errorString.contains('socket') || 
                 errorString.contains('network') ||
                 errorString.contains('connection')) {
        throw ApiException('Network error: ${e.toString()}', ErrorType.noInternet);
      } else {
        throw ApiException('Error: ${e.toString()}', ErrorType.unknown);
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsTrends(String timeframe) async {
    try {
      final uri = Uri.parse('$baseUrl/analytics/trends').replace(
        queryParameters: {'timeframe': timeframe},
      );
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        
        if (jsonData.containsKey('data')) {
          return jsonData['data'] as Map<String, dynamic>;
        } else {
          throw ApiException('Unexpected response format: missing data field', ErrorType.unknown);
        }
      } else {
        throw ApiException(
          'Failed to load analytics trends: ${response.statusCode}',
          ErrorType.serverError,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', ErrorType.noInternet);
    } on HttpException catch (e) {
      throw ApiException('HTTP error: ${e.message}', ErrorType.serverError);
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}', ErrorType.unknown);
    } on http.ClientException {
      throw ApiException('Network error: Unable to connect to server', ErrorType.noInternet);
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('timeout') || errorString.contains('timed out')) {
        throw ApiException('Request timeout', ErrorType.timeout);
      } else if (errorString.contains('socket') || 
                 errorString.contains('network') ||
                 errorString.contains('connection')) {
        throw ApiException('Network error: ${e.toString()}', ErrorType.noInternet);
      } else {
        throw ApiException('Error: ${e.toString()}', ErrorType.unknown);
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getAnalyticsSentiment() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/analytics/sentiment'))
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        
        if (jsonData.containsKey('data')) {
          return jsonData['data'] as Map<String, dynamic>;
        } else {
          throw ApiException('Unexpected response format: missing data field', ErrorType.unknown);
        }
      } else {
        throw ApiException(
          'Failed to load analytics sentiment: ${response.statusCode}',
          ErrorType.serverError,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', ErrorType.noInternet);
    } on HttpException catch (e) {
      throw ApiException('HTTP error: ${e.message}', ErrorType.serverError);
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}', ErrorType.unknown);
    } on http.ClientException {
      throw ApiException('Network error: Unable to connect to server', ErrorType.noInternet);
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('timeout') || errorString.contains('timed out')) {
        throw ApiException('Request timeout', ErrorType.timeout);
      } else if (errorString.contains('socket') || 
                 errorString.contains('network') ||
                 errorString.contains('connection')) {
        throw ApiException('Network error: ${e.toString()}', ErrorType.noInternet);
      } else {
        throw ApiException('Error: ${e.toString()}', ErrorType.unknown);
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getPortfolioSummary() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/portfolio'))
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        
        if (jsonData.containsKey('data')) {
          return jsonData['data'] as Map<String, dynamic>;
        } else {
          throw ApiException('Unexpected response format: missing data field', ErrorType.unknown);
        }
      } else {
        throw ApiException(
          'Failed to load portfolio summary: ${response.statusCode}',
          ErrorType.serverError,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', ErrorType.noInternet);
    } on HttpException catch (e) {
      throw ApiException('HTTP error: ${e.message}', ErrorType.serverError);
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}', ErrorType.unknown);
    } on http.ClientException {
      throw ApiException('Network error: Unable to connect to server', ErrorType.noInternet);
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('timeout') || errorString.contains('timed out')) {
        throw ApiException('Request timeout', ErrorType.timeout);
      } else if (errorString.contains('socket') || 
                 errorString.contains('network') ||
                 errorString.contains('connection')) {
        throw ApiException('Network error: ${e.toString()}', ErrorType.noInternet);
      } else {
        throw ApiException('Error: ${e.toString()}', ErrorType.unknown);
      }
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getPortfolioHoldings() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/portfolio/holdings'))
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        
        if (jsonData.containsKey('data')) {
          final data = jsonData['data'];
          if (data is List) {
            return List<Map<String, dynamic>>.from(data);
          } else {
            throw ApiException('Unexpected data format: expected array', ErrorType.unknown);
          }
        } else {
          throw ApiException('Unexpected response format: missing data field', ErrorType.unknown);
        }
      } else {
        throw ApiException(
          'Failed to load portfolio holdings: ${response.statusCode}',
          ErrorType.serverError,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', ErrorType.noInternet);
    } on HttpException catch (e) {
      throw ApiException('HTTP error: ${e.message}', ErrorType.serverError);
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}', ErrorType.unknown);
    } on http.ClientException {
      throw ApiException('Network error: Unable to connect to server', ErrorType.noInternet);
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('timeout') || errorString.contains('timed out')) {
        throw ApiException('Request timeout', ErrorType.timeout);
      } else if (errorString.contains('socket') || 
                 errorString.contains('network') ||
                 errorString.contains('connection')) {
        throw ApiException('Network error: ${e.toString()}', ErrorType.noInternet);
      } else {
        throw ApiException('Error: ${e.toString()}', ErrorType.unknown);
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getPortfolioPerformance(String timeframe) async {
    try {
      final uri = Uri.parse('$baseUrl/portfolio/performance').replace(
        queryParameters: {'timeframe': timeframe},
      );
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        
        if (jsonData.containsKey('data')) {
          return jsonData['data'] as Map<String, dynamic>;
        } else {
          throw ApiException('Unexpected response format: missing data field', ErrorType.unknown);
        }
      } else {
        throw ApiException(
          'Failed to load portfolio performance: ${response.statusCode}',
          ErrorType.serverError,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', ErrorType.noInternet);
    } on HttpException catch (e) {
      throw ApiException('HTTP error: ${e.message}', ErrorType.serverError);
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}', ErrorType.unknown);
    } on http.ClientException {
      throw ApiException('Network error: Unable to connect to server', ErrorType.noInternet);
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('timeout') || errorString.contains('timed out')) {
        throw ApiException('Request timeout', ErrorType.timeout);
      } else if (errorString.contains('socket') || 
                 errorString.contains('network') ||
                 errorString.contains('connection')) {
        throw ApiException('Network error: ${e.toString()}', ErrorType.noInternet);
      } else {
        throw ApiException('Error: ${e.toString()}', ErrorType.unknown);
      }
    }
  }

  @override
  Future<Map<String, dynamic>> addTransaction(Map<String, dynamic> transaction) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/portfolio/transactions'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(transaction),
          )
          .timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body) as Map<String, dynamic>;
        
        if (jsonData.containsKey('data')) {
          return jsonData['data'] as Map<String, dynamic>;
        } else {
          throw ApiException('Unexpected response format: missing data field', ErrorType.unknown);
        }
      } else {
        final errorBody = json.decode(response.body) as Map<String, dynamic>?;
        final errorMessage = errorBody?['error']?['message'] as String?;
        throw ApiException(
          errorMessage ?? 'Failed to add transaction: ${response.statusCode}',
          ErrorType.serverError,
        );
      }
    } on SocketException {
      throw ApiException('No internet connection', ErrorType.noInternet);
    } on HttpException catch (e) {
      throw ApiException('HTTP error: ${e.message}', ErrorType.serverError);
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}', ErrorType.unknown);
    } on http.ClientException {
      throw ApiException('Network error: Unable to connect to server', ErrorType.noInternet);
    } catch (e) {
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('timeout') || errorString.contains('timed out')) {
        throw ApiException('Request timeout', ErrorType.timeout);
      } else if (errorString.contains('socket') || 
                 errorString.contains('network') ||
                 errorString.contains('connection')) {
        throw ApiException('Network error: ${e.toString()}', ErrorType.noInternet);
      } else {
        throw ApiException('Error: ${e.toString()}', ErrorType.unknown);
      }
    }
  }
}
