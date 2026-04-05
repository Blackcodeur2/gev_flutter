import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/models/user_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client_service.dart';

class AuthResponse {
  final bool success;
  final String? message;
  final UserModel? user;

  AuthResponse({required this.success, this.message, this.user});
}

class AuthService {
  final Dio dio = ApiClient().dio;
  final storage = const FlutterSecureStorage();

  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await dio.post(
        "/login",
        data: {"email": email, "password": password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data["token"];
        final userData = response.data["user"];
        
        await storage.write(key: AppConstants.tokenKey, value: token);
        // On pourrait aussi stocker les données utilisateur en local ici
        
        return AuthResponse(
          success: true,
          user: UserModel.fromJson(userData),
        );
      }
      
      return AuthResponse(success: false, message: "Identifiants incorrects");
    } on DioException catch (e) {
      String message = "Une erreur est survenue";
      if (e.response?.statusCode == 422) {
        message = "Données invalides";
      } else if (e.response?.statusCode == 401) {
        message = "Email ou mot de passe incorrect";
      }
      return AuthResponse(success: false, message: message);
    } catch (e) {
      return AuthResponse(success: false, message: e.toString());
    }
  }

  Future<void> logout() async {
    try {
      // Appel au backend pour révoquer le token Sanctum
      await dio.post("/logout");
    } catch (e) {
      print("Erreur logout backend: $e");
    } finally {
      // Suppression locale quoi qu'il arrive
      await storage.delete(key: AppConstants.tokenKey);
    }
  }

  Future<bool> isLoggedIn() async {
    String? token = await storage.read(key: AppConstants.tokenKey);
    return token != null;
  }
}
