import 'package:camer_trip/app/screens/agences/agence_details_page.dart';
import 'package:camer_trip/app/models/ag_model.dart';
import 'package:camer_trip/app/screens/auth/login.dart';
import 'package:camer_trip/app/screens/auth/register.dart';
import 'package:camer_trip/app/screens/history/reservation_details_page.dart';
import 'package:camer_trip/app/screens/notifications/notification_page.dart';
import 'package:camer_trip/app/screens/onboarding/onboarding.dart';
import 'package:camer_trip/app/screens/splash/splash.dart';
import 'package:camer_trip/app/models/reservation_model.dart';
import 'package:camer_trip/app/screens/settings/kwc_page.dart';
import 'package:camer_trip/app/screens/settings/about_page.dart';
import 'package:camer_trip/app/screens/settings/faq_page.dart';
import 'package:camer_trip/app/utils/main_page.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  // ── Noms de routes ────────────────────────────────────────────────────────
  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String login = 'login';
  static const String register = 'register';
  static const String main = 'main';
  static const String notifications = 'notifications';
  static const String reservationDetails = 'reservationDetails';
  static const String agenceDetails = 'agenceDetails';
  static const String kwc = 'kwc';
  static const String about = 'about';
  static const String faq = 'faq';
  // ── Chemins de routes ─────────────────────────────────────────────────────
  static const String splashPath = '/';
  static const String onboardingPath = '/onboarding';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String mainPath = '/main';
  static const String notificationPath = '/notifications';
  static const String reservationDetailsPath = '/reservation-details';
  static const String agenceDetailsPath = '/agence-details';
  static const String kwcPath = '/kwc';
  static const String aboutPath = '/about';
  static const String faqPath = '/faq';
  // ── Simulation AuthService (à remplacer) ──────────────────────────────────
  static bool _isLoggedIn = false;

  static void setLoggedIn(bool value) => _isLoggedIn = value;

  // ── Routeur GoRouter ──────────────────────────────────────────────────────
  static final GoRouter router = GoRouter(
    initialLocation: splashPath,
    debugLogDiagnostics: true,

    // 🔐 Redirection globale
    redirect: (context, state) async {
      final loc = state.matchedLocation;

      // Routes publiques (accessibles sans auth)
      final publicRoutes = [
        splashPath,
        onboardingPath,
        loginPath,
        registerPath,
      ];
      final isPublic = publicRoutes.contains(loc);

      if (!_isLoggedIn && !isPublic) {
        return loginPath;
      }

      // Si connecté et va vers login/register → redirige vers main
      if (_isLoggedIn && (loc == loginPath || loc == registerPath)) {
        return mainPath;
      }

      return null;
    },

    routes: [
      // ── Splash ─────────────────────────────────────────────────────────
      GoRoute(
        path: splashPath,
        name: splash,
        builder: (context, state) => const SplashPage(),
      ),

      // ── Onboarding ─────────────────────────────────────────────────────
      GoRoute(
        path: onboardingPath,
        name: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),

      // ── Auth ───────────────────────────────────────────────────────────
      GoRoute(
        path: loginPath,
        name: login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: registerPath,
        name: register,
        builder: (context, state) => const RegisterPage(),
      ),

      // ── App principale ─────────────────────────────────────────────────
      GoRoute(
        path: mainPath,
        name: main,
        builder: (context, state) => const MainPage(),
      ),

      // -- Notifications
      GoRoute(
        path: notificationPath,
        name: notifications,
        builder: (context, state) => const NotificationPage(),
      ),

      // -- Reservation Details
      GoRoute(
        path: reservationDetailsPath,
        name: reservationDetails,
        builder: (context, state) {
          final res = state.extra as ReservationModel;
          return ReservationDetailsPage(reservation: res);
        },
      ),

      // -- Agence Details
      GoRoute(
        path: agenceDetailsPath,
        name: agenceDetails,
        builder: (context, state) {
          final ag = state.extra as Agence;
          return AgenceDetailsPage(agence: ag);
        },
      ),

      // -- KWC Verification
      GoRoute(
        path: kwcPath,
        name: kwc,
        builder: (context, state) => const KwcPage(),
      ),
      GoRoute(
        path: aboutPath,
        name: about,
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: faqPath,
        name: faq,
        builder: (context, state) => const FaqPage(),
      ),
    ],
  );
}
