import 'dart:developer';
import 'package:camer_trip/app/config/colors_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:camer_trip/app/services/api_client_service.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/routes/app_routter.dart';

// Déclaration de la fonction en dehors de toute classe pour l'exécution en arrière-plan
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Message reçu en arrière-plan: ${message.messageId}");
}

class PushNotificationService {
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    final messaging = FirebaseMessaging.instance;
    // Demander les permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log('Autorisation des notifications : ${settings.authorizationStatus}');

    // Configuration des notifications locales
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
        
    await _localNotificationsPlugin.initialize(
     
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log("Clic sur la notification locale: ${response.payload}");
        // Redirection vers la page des notifications
        AppRouter.router.pushNamed(AppRouter.notifications);
      }, settings: initializationSettings,
    );

    // Enregistrement du handler d'arrière-plan
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Gérer les messages quand l'application est au premier plan
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Message reçu au premier plan : ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // Gérer le clic quand l'application est en arrière-plan et s'ouvre
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Clic sur la notification (app en arrière-plan): ${message.data}');
      // Redirection vers la page des notifications
      AppRouter.router.pushNamed(AppRouter.notifications);
    });

    // Récupérer et envoyer le token au backend
    await sendTokenToBackend();

    // Écouter le rafraîchissement du token
    messaging.onTokenRefresh.listen((newToken) {
      _sendTokenToBackend(newToken);
    });
  }

  static Future<void> sendTokenToBackend() async {
    try {
      final String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _sendTokenToBackend(token);
      }
    } catch (e) {
      log("Erreur lors de la récupération du token FCM: $e");
    }
  }

  static Future<void> _sendTokenToBackend(String fcmToken) async {
    try {
      final apiClient = ApiClient();
      final storage = apiClient.storage;
      String? userToken = await storage.read(key: AppConstants.tokenKey);
      
      String endpoint = userToken != null ? '/user/fcm-token' : '/fcm-token';
      
      await apiClient.dio.post(endpoint, data: {
        'fcm_token': fcmToken,
        'device_type': 'android', // Ajustez selon la plateforme
      });
      log("Token FCM envoyé au backend avec succès.");
    } catch (e) {
      log("Erreur lors de l'envoi du token FCM au backend: $e");
    }
  }

  static Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotificationsPlugin.show(
        id: notification.hashCode,
        title: notification.title,
        body: notification.body,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'camer_trip_channel',
            'Notifications Camer Trip',
            channelDescription: 'Canal principal pour les notifications',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
            color: AppColors.primaryGreen,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }
}
