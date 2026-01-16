import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../interfaces/cache_service_interface.dart';

class CacheService implements ICacheService {
  static const String _marketDataKey = 'market_data_cache';
  static const String _cacheTimestampKey = 'market_data_cache_timestamp';
  static const Duration _defaultMaxAge = Duration(minutes: 5);

  @override
  Future<void> saveMarketData(List<Map<String, dynamic>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(data);
      await prefs.setString(_marketDataKey, jsonString);
      await prefs.setString(_cacheTimestampKey, DateTime.now().toIso8601String());
    } catch (e) {
      // Silently fail - cache is not critical
      debugPrint('Error saving cache: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>?> getMarketData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_marketDataKey);
      
      if (jsonString == null) {
        return null;
      }
      
      final decoded = json.decode(jsonString);
      if (decoded is List) {
        return List<Map<String, dynamic>>.from(decoded);
      }
      
      return null;
    } catch (e) {
      debugPrint('Error reading cache: $e');
      return null;
    }
  }

  @override
  Future<bool> hasValidCache({Duration? maxAge}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampString = prefs.getString(_cacheTimestampKey);
      
      if (timestampString == null) {
        return false;
      }
      
      final timestamp = DateTime.parse(timestampString);
      final age = DateTime.now().difference(timestamp);
      final maxCacheAge = maxAge ?? _defaultMaxAge;
      
      return age < maxCacheAge && await getMarketData() != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_marketDataKey);
      await prefs.remove(_cacheTimestampKey);
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  @override
  Future<DateTime?> getCacheTimestamp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestampString = prefs.getString(_cacheTimestampKey);
      
      if (timestampString == null) {
        return null;
      }
      
      return DateTime.parse(timestampString);
    } catch (e) {
      return null;
    }
  }
}
