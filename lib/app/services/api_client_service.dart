import 'package:camer_trip/app/config/const_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late Dio dio;
  final storage = const FlutterSecureStorage();

  // Singleton instance
  static final ApiClient _instance = ApiClient._internal();
  
  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiBaseUrl,
        connectTimeout: AppConstants.apiTimeOut,
        receiveTimeout: AppConstants.apiTimeOut,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      ),
    );

    // Logger for debugging
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
    ));

    // Token Injector Interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await storage.read(key: AppConstants.tokenKey);
          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Logic for auto-logout (e.g., deleting token)
            await storage.delete(key: AppConstants.tokenKey);
            print("Session expirée (401)");
          }
          return handler.next(e);
        },
      ),
    );
  }
}