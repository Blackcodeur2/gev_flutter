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
        data: {"login": email, "password": password},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data["data"]["token"];
        final userData = response.data["data"]["user"];

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
      } else if (e.response?.statusCode == 403) {
        message = e.response?.data['message'] ?? "Veuillez vérifier votre email avant de vous connecter.";
      }
      return AuthResponse(success: false, message: message);
    } catch (e) {
      return AuthResponse(success: false, message: e.toString());
    }
  }

  Future<AuthResponse> loginWithGoogle(String idToken) async {
    try {
      final response = await dio.post(
        "/google-login",
        data: {"idToken": idToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = response.data["data"]["token"];
        final userData = response.data["data"]["user"];

        await storage.write(key: AppConstants.tokenKey, value: token);
        await storage.write(
          key: AppConstants.userDataKey,
          value: jsonEncode(userData),
        );

        return AuthResponse(success: true, user: UserModel.fromJson(userData));
      }

      return AuthResponse(success: false, message: "Échec de la connexion Google");
    } on DioException catch (e) {
      String message = e.response?.data['message'] ?? "Erreur lors de la connexion Google";
      return AuthResponse(success: false, message: message);
    } catch (e) {
      return AuthResponse(success: false, message: e.toString());
    }
  }

  Future<AuthResponse> register({
    required String nom,
    required String prenom,
    required String email,
    required String telephone,
    required String dateNaissance,
    required String sexe,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await dio.post(
        "/register",
        data: {
          "nom": nom,
          "prenom": prenom,
          "email": email,
          "telephone": telephone,
          "date_naissance": dateNaissance,
          "sexe": sexe,
          "password": password,
          "password_confirmation": passwordConfirmation,
          "role_user": "CLIENT",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Le backend ne renvoie plus de token à l'inscription pour forcer la vérification d'email
        final userData = response.data["data"]["user"];

        return AuthResponse(
          success: true,
          message: response.data["message"] ??
              "Inscription réussie. Veuillez vérifier votre email.",
          user: UserModel.fromJson(userData),
        );
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
      print("Syncing user data from /profile...");
      final response = await dio.get("/profile");

      if (response.statusCode == 200) {
        final userData = response.data["data"];
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
  Future<AuthResponse> updateProfile({
    String? nom,
    String? prenom,
    String? email,
    String? telephone,
    String? dateNaissance,
    String? sexe,
    File? avatar,
  }) async {
    try {
      Map<String, dynamic> data = {};
      if (nom != null) data['nom'] = nom;
      if (prenom != null) data['prenom'] = prenom;
      if (email != null) data['email'] = email;
      if (telephone != null) data['telephone'] = telephone;
      if (dateNaissance != null) data['date_naissance'] = dateNaissance;
      if (sexe != null) data['sexe'] = sexe;

      if (avatar != null) {
        String fileName = avatar.path.split('/').last;
        data['avatar'] = await MultipartFile.fromFile(avatar.path, filename: fileName);
      }

      FormData formData = FormData.fromMap(data);

      final response = await dio.post(
        "/user/update-profile",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = response.data["data"];
        await storage.write(
          key: AppConstants.userDataKey,
          value: jsonEncode(userData),
        );
        return AuthResponse(success: true, user: UserModel.fromJson(userData));
      }

      return AuthResponse(success: false, message: "Échec de la mise à jour");
    } on DioException catch (e) {
      print("Update Profile Error: ${e.response?.data}");
      String message = "Une erreur est survenue lors de la mise à jour";
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null && errors is Map) {
          message = errors.values.first[0].toString();
        }
      } else {
        message = e.response?.data['message'] ?? message;
      }
      return AuthResponse(success: false, message: message);
    } catch (e) {
      return AuthResponse(success: false, message: e.toString());
    }
  }

  Future<AuthResponse> forgotPassword(String email) async {
    try {
      final response = await dio.post("/forgot-password", data: {"email": email});
      return AuthResponse(
        success: response.data["success"] ?? true,
        message: response.data["message"] ?? "Un lien et un code ont été envoyés.",
      );
    } on DioException catch (e) {
      return AuthResponse(
        success: false,
        message: e.response?.data["message"] ?? "Erreur lors de l'envoi de l'email",
      );
    }
  }

  Future<AuthResponse> resetPasswordOtp({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await dio.post("/reset-password-otp", data: {
        "email": email,
        "code": code,
        "password": password,
        "password_confirmation": passwordConfirmation,
      });
      return AuthResponse(
        success: response.data["success"] ?? true,
        message: response.data["message"] ?? "Mot de passe réinitialisé.",
      );
    } on DioException catch (e) {
      return AuthResponse(
        success: false,
        message: e.response?.data["message"] ?? "Erreur lors de la réinitialisation",
      );
    }
  }

  Future<AuthResponse> verifyEmailOtp(String email, String code) async {
    try {
      final response = await dio.post("/email/verify-otp", data: {
        "email": email,
        "code": code,
      });
      return AuthResponse(
        success: response.data["success"] ?? true,
        message: response.data["message"] ?? "Email vérifié avec succès.",
      );
    } on DioException catch (e) {
      return AuthResponse(
        success: false,
        message: e.response?.data["message"] ?? "Code invalide ou expiré.",
      );
    }
  }

  Future<AuthResponse> verifyEmailLink(String id, String hash) async {
    try {
      final response = await dio.get("/email/verify/$id/$hash");
      return AuthResponse(
        success: response.data["success"] ?? true,
        message: response.data["message"] ?? "Email vérifié avec succès.",
      );
    } on DioException catch (e) {
      return AuthResponse(
        success: false,
        message: e.response?.data["message"] ?? "Lien invalide ou expiré.",
      );
    }
  }

  Future<AuthResponse> resendVerificationEmail() async {
    try {
      final response = await dio.post("/email/resend");
      return AuthResponse(
        success: response.data["success"] ?? true,
        message: response.data["message"] ?? "Email de vérification renvoyé.",
      );
    } on DioException catch (e) {
      return AuthResponse(
        success: false,
        message: e.response?.data["message"] ?? "Erreur lors de l'envoi.",
      );
    }
  }
}

