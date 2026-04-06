import 'dart:convert';
import 'dart:io';
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
        await storage.write(
          key: AppConstants.userDataKey,
          value: jsonEncode(userData),
        );

        return AuthResponse(success: true, user: UserModel.fromJson(userData));
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

  Future<AuthResponse> register({
    required String nom,
    required String prenom,
    required String numCni,
    required String email,
    required String telephone,
    required String dateNaissance,
    required String password,
    int? gareId,
    String? roleUser,
  }) async {
    try {
      final response = await dio.post(
        "/register",
        data: {
          "nom": nom,
          "prenom": prenom,
          "num_cni": numCni,
          "email": email,
          "telephone": telephone,
          "date_naissance": dateNaissance,
          "password": password,
          "role_user": roleUser ?? "CLIENT",
          "gare_id": gareId,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data["token"];
        final userData = response.data["user"];

        await storage.write(key: AppConstants.tokenKey, value: token);
        await storage.write(
          key: AppConstants.userDataKey,
          value: jsonEncode(userData),
        );

        return AuthResponse(success: true, user: UserModel.fromJson(userData));
      }

      return AuthResponse(success: false, message: "Échec de l'inscription");
    } on DioException catch (e) {
      print("Register DioException: ${e.response?.data}");
      String message = "Une erreur est survenue lors de l'inscription";
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null && errors is Map) {
          message = errors.values.first[0].toString();
        } else {
          message = "Données déjà utilisées ou invalides";
        }
      } else {
        message = e.response?.data['message'] ?? e.message ?? message;
      }
      return AuthResponse(success: false, message: message);
    } catch (e) {
      print("Register Error: $e");
      return AuthResponse(
        success: false,
        message: "Erreur locale : ${e.toString()}",
      );
    }
  }

  Future<void> logout() async {
    try {
      await dio.post("/logout");
    } catch (e) {
      print("Erreur logout backend: $e");
    } finally {
      await storage.delete(key: AppConstants.tokenKey);
      await storage.delete(key: AppConstants.userDataKey);
    }
  }

  Future<bool> isLoggedIn() async {
    String? token = await storage.read(key: AppConstants.tokenKey);
    return token != null;
  }

  Future<UserModel?> getUser() async {
    final data = await storage.read(key: AppConstants.userDataKey);
    if (data != null) {
      try {
        return UserModel.fromJson(jsonDecode(data));
      } catch (e) {
        print("Erreur parsing user data: $e");
        return null;
      }
    }
    return null;
  }

  Future<AuthResponse> syncUser() async {
    try {
      print("Syncing user data from /user...");
      final response = await dio.get("/user");
      if (response.statusCode == 200) {
        final userData = response.data;
        print("Sync Success! New Statut: ${userData['statut']}");
        await storage.write(
          key: AppConstants.userDataKey,
          value: jsonEncode(userData),
        );
        return AuthResponse(success: true, user: UserModel.fromJson(userData));
      }
      return AuthResponse(success: false, message: "Impossible de synchroniser");
    } on DioException catch (e) {
      print("Sync DioException: ${e.response?.statusCode} - ${e.response?.data}");
      return AuthResponse(success: false, message: e.message);
    } catch (e) {
      print("Sync Error: $e");
      return AuthResponse(success: false, message: e.toString());
    }
  }

  Future<AuthResponse> uploadKwcDocument(File file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "type": "cni",
        "fichier": await MultipartFile.fromFile(file.path, filename: fileName),
        "commentaire":
            "", // Optionnel, mais on envoie vide comme demandé par le contrôleur
      });

      final response = await dio.post(
        "/client/upload-cni",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AuthResponse(
          success: true,
          message: "Document envoyé avec succès",
        );
      }

      return AuthResponse(success: false, message: "Échec de l'envoi");
    } on DioException catch (e) {
      print("Upload Error: ${e.response?.data}");
      return AuthResponse(
        success: false,
        message:
            e.response?.data['message'] ?? "Erreur lors de l'envoi du document",
      );
    } catch (e) {
      return AuthResponse(success: false, message: e.toString());
    }
  }
}
