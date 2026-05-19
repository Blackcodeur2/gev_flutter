import 'package:camer_trip/app/models/user_model.dart';
import 'package:riverpod/riverpod.dart';
import 'api_client_service.dart';
import 'auth_service.dart';
import 'home_service.dart';
import 'kwc_service.dart';
import 'voyage_service.dart';
import 'reservation_service.dart';
import 'paiement_service.dart';
import 'colis_service.dart';
import '../models/colis_model.dart';
import 'notification_service.dart';
import '../models/notification_model.dart';
import 'annonce_service.dart';
import '../models/annonce_model.dart';



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

final reservationServiceProvider = Provider<ReservationService>((ref) {
  return ReservationService();
});


final homeServiceProvider = Provider<HomeService>((ref) {
  return HomeService();
});

final paiementServiceProvider = Provider<PaiementService>((ref) {
  return PaiementService();
});

final colisServiceProvider = Provider<ColisService>((ref) {
  return ColisService();
});

final myColisProvider = FutureProvider<List<ColisModel>>((ref) async {
  return ref.watch(colisServiceProvider).getMyColis();
});



final agencesProvider = FutureProvider((ref) async {
  return ref.watch(homeServiceProvider).getAgencesPartenaires();
});

final destinationsProvider = FutureProvider((ref) async {
  return ref.watch(homeServiceProvider).getDestinationsPopulaires();
});

final promosProvider = FutureProvider((ref) async {
  return ref.watch(homeServiceProvider).getPromoTrips();
});

// Provider pour vérifier l'état de connexion de l'utilisateur
final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.isLoggedIn();
});

final myReservationsProvider = FutureProvider((ref) async {
  return ref.watch(reservationServiceProvider).getMyReservations();
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

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final myNotificationsProvider = StreamProvider<List<NotificationModel>>((ref) async* {
  final isLoggedIn = ref.watch(isLoggedInProvider).value ?? false;
  if (!isLoggedIn) {
    yield [];
    return;
  }

  final notificationService = ref.watch(notificationServiceProvider);
  
  // Émettre immédiatement les données actuelles
  yield await notificationService.getNotifications();

  // Puis rafraîchir toutes les 15 secondes pour le temps réel
  yield* Stream.periodic(const Duration(seconds: 15)).asyncMap((_) async {
    return await notificationService.getNotifications();
  });
});

final annonceServiceProvider = Provider<AnnonceService>((ref) {
  return AnnonceService();
});

final annoncesProvider = FutureProvider<List<AnnonceModel>>((ref) async {
  return ref.watch(annonceServiceProvider).getAnnonces();
});
