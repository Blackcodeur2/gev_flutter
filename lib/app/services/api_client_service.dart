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

    final baseUrl = await _instance._findAvailableBaseUrl();
    _instance._configureDio(baseUrl);
    _initialized = true;
    return _instance;
  }

  Future<String> _findAvailableBaseUrl() async {
    for (final url in AppConstants.apiBaseUrls) {
      try {
        final testDio = Dio(
          BaseOptions(
            baseUrl: url,
            connectTimeout: AppConstants.apiTimeOut,
            receiveTimeout: AppConstants.apiTimeOut,
          ),
        );

        await testDio.get(
          '',
          options: Options(validateStatus: (_) => true),
        );

        print('ApiClient: base URL disponible -> $url');
        return url;
      } catch (_) {
        print('ApiClient: échec de connexion à $url');
      }
    }

    print('ApiClient: aucune base URL disponible, utilisation de la valeur par défaut.');
    return AppConstants.apiBaseUrl;
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
