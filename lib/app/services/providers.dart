import 'package:camer_trip/app/models/user_model.dart';
import 'package:riverpod/riverpod.dart';
import 'api_client_service.dart';
import 'auth_service.dart';
import 'kwc_service.dart';
import 'voyage_service.dart';

// Fournit l'instance Singleton de l'ApiClient (Dio)
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Fournit l'AuthService
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Fournit le KwcService
final kwcServiceProvider = Provider<KwcService>((ref) {
  return KwcService();
});

// Fournit le VoyageService
final voyageServiceProvider = Provider<VoyageService>((ref) {
  return VoyageService();
});

// Provider pour vérifier l'état de connexion de l'utilisateur
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.isLoggedIn();
});

// Provider pour récupérer l'utilisateur actuel
final currentUserProvider = FutureProvider<UserModel?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.getUser();
});

// Méthode pour forcer la synchronisation avec le serveur
final syncUserProvider = FutureProvider<AuthResponse>((ref) async {
  final authService = ref.watch(authServiceProvider);
  final response = await authService.syncUser();
  if (response.success) {
    ref.invalidate(currentUserProvider);
  }
  return response;
});
