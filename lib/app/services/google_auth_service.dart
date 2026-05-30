import 'package:google_sign_in/google_sign_in.dart';
import '../utils/api_error_handler.dart';
import 'auth_service.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  final AuthService _authService = AuthService();

  Future<AuthResponse> signIn() async {
    try {
      // Forcer la déconnexion pour afficher la modale de sélection de compte
      await _googleSignIn.signOut();
      
      // Déclencher le flux d'authentification Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return AuthResponse(success: false, message: "Connexion annulée par l'utilisateur.");
      }

      // Obtenir les détails d'authentification de la demande
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Envoyer le token au backend Laravel
      if (googleAuth.idToken != null) {
        return await _authService.loginWithGoogle(googleAuth.idToken!);
      } else {
        return AuthResponse(success: false, message: "Impossible de récupérer le token Google.");
      }
    } catch (error) {
      print("Erreur Google Sign-In: $error");
      return AuthResponse(
        success: false,
        message: ApiErrorHandler.userMessage(
          error,
          fallback: "Erreur lors de la connexion avec Google",
        ),
      );
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
