import 'package:get_it/get_it.dart';
import 'api_service.dart';
import '../interfaces/api_service_interface.dart';
import 'cache_service.dart';
import '../interfaces/cache_service_interface.dart';
import 'analytics_tracking_service.dart';
import 'websocket_service.dart';
import '../interfaces/websocket_service_interface.dart';

final getIt = GetIt.instance;

/// Initialize dependency injection
void setupServiceLocator() {
  // Register Cache Service
  getIt.registerLazySingleton<ICacheService>(() => CacheService());
  
  // Register API Service
  getIt.registerLazySingleton<IApiService>(() => ApiService());
  
  // Register Analytics Tracking Service (singleton)
  getIt.registerLazySingleton<AnalyticsTrackingService>(() => AnalyticsTrackingService());
  
  // Register WebSocket Service (singleton)
  getIt.registerLazySingleton<IWebSocketService>(() => WebSocketService());
}
