class AppConstants {
  // INFORMATIONS SUR L'APPLICATION
  static const String appName = 'CamerTrip';
  static const String appDescription =
      'La planification de votre voyage n\'a jamais ete aussi simple';

  // CONFIGURATIONS API
  static const String apiVersion = 'v1';
  static const Duration apiTimeOut = Duration(seconds: 10);
  static const String apiBaseUrl = 'http://192.168.1.144:8000/api';

  // CONFIGURATIONS DIMENSIONS
  static const double defaultPadding = 11.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 12.0;
  static const double largeBorderRadius = 20.0;
  static const double buttonHeight = 50.0;
  static const double cardElevation = 5.0;

  // CONFIGURATION LOCAL STORAGE
  static const String userDataKey = 'user';
  static const String tokenKey = 'token';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String notificationKey = 'notification_enabled';

  // CONFIGURATION PAIEMENTS
  static const List<String> paymentMethods = [
    'Orange Money',
    'MTN Mobile Money',
  ];

  // Error Messages
  static const String networkError = 'Erreur de connexion réseau';
  static const String serverError = 'Erreur du serveur';
  static const String unknownError = 'Une erreur inconnue s\'est produite';
  static const String authError = 'Erreur d\'authentification';

  // Success Messages
  static const String reservationSuccess = 'Réservation effectuée avec succès';
  static const String paymentSuccess = 'Paiement effectué avec succès';
  static const String profileUpdated = 'Profil mis à jour avec succès';
}
