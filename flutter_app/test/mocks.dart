import 'package:mockito/annotations.dart';
import 'package:pulsenow_flutter/interfaces/api_service_interface.dart';
import 'package:pulsenow_flutter/interfaces/cache_service_interface.dart';
import 'package:pulsenow_flutter/interfaces/websocket_service_interface.dart';

// Generate mocks for interfaces
@GenerateMocks([
  IApiService,
  ICacheService,
  IWebSocketService,
])
void main() {}
