import 'package:camer_trip/app/config/const_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  late Dio dio;
  final storage = const FlutterSecureStorage();

  ApiClient(){
    dio = Dio(
        BaseOptions(
            baseUrl: AppConstants.apiBaseUrl,
            connectTimeout: AppConstants.apiTimeOut,
            receiveTimeout: AppConstants.apiTimeOut,
            headers: {
                "Accept": "application/json",
            },
        ),
    );

    // Ajout de l'intercepteur pour ajouter automatiquement le token
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? tocken = await storage.read(key: AppConstants.tokenKey);
          if(tocken != null){
            options.headers["Authorization"] = "Bearer $tocken";
          }
          return handler.next(options);
        },
      ),
    );
  }
}