import 'package:camer_trip/app/config/const_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/experimental/persist.dart';
import 'api_client_service.dart';

class AuthService {
  final Dio dio = ApiClient().dio;
  final storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    try {
      final response = await dio.post(
        "/login",
        data: {"email": email, "password": password},
      );

      final token = response.data["token"];
      await storage.write(key: AppConstants.tokenKey, value: token);
      return true;
    } catch (e) {
      print("Erreur login: $e");
      return false;
    }
  }

  Future<void> logout() async {
    await storage.delete(key: AppConstants.tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final storage = this.storage;
    String? token = await storage.read(key: AppConstants.tokenKey);
    return token != null;
  }
}
