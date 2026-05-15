import 'package:camer_trip/app/config/const_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late Dio dio;
  final storage = const FlutterSecureStorage();

  static final ApiClient _instance = ApiClient._private();
  static bool _initialized = false;

  factory ApiClient() {
    if (!_initialized) {
      throw StateError('ApiClient doit être initialisé en appelant ApiClient.init() avant toute utilisation.');
    }
    return _instance;
  }

  ApiClient._private();

  String get baseUrl => dio.options.baseUrl;


  static Future<ApiClient> init() async {
    if (_initialized) {
      return _instance;
    }

    _instance._configureDio(AppConstants.apiBaseUrl);
    _initialized = true;
    return _instance;
  }

  void _configureDio(String baseUrl) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
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
            await storage.delete(key: AppConstants.tokenKey);
            print("Session expirée (401)");
          }
          return handler.next(e);
        },
      ),
    );
  }
}
