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
import 'package:camer_trip/app/screens/books/booking_page.dart';
import 'package:camer_trip/app/screens/books/payment_page.dart';
import 'package:camer_trip/app/screens/colis/my_colis_page.dart';
import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:camer_trip/app/screens/settings/edit_profile_page.dart';
import 'package:camer_trip/app/models/user_model.dart';
import 'package:camer_trip/app/utils/main_page.dart';
import 'package:go_router/go_router.dart';

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
  static const String booking = 'booking';
  static const String payment = 'payment';
  static const String myColis = 'myColis';
  static const String editProfile = 'editProfile';


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
  static const String bookingPath = '/booking';
  static const String paymentPath = '/payment';
  static const String myColisPath = '/my-colis';
  static const String editProfilePath = '/edit-profile';


  // ── Simulation AuthService ──────────────────────────────────
  static bool _isLoggedIn = false;
  static void setLoggedIn(bool value) => _isLoggedIn = value;

  // ── Routeur GoRouter ──────────────────────────────────────────────────────
  static final GoRouter router = GoRouter(
    initialLocation: splashPath,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final loc = state.matchedLocation;
      final publicRoutes = [splashPath, onboardingPath, loginPath, registerPath];
      final isPublic = publicRoutes.contains(loc);

      if (!_isLoggedIn && !isPublic) return loginPath;
      if (_isLoggedIn && (loc == loginPath || loc == registerPath)) return mainPath;
      return null;
    },
    routes: [
      GoRoute(path: splashPath, name: splash, builder: (context, state) => const SplashPage()),
      GoRoute(path: onboardingPath, name: onboarding, builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: loginPath, name: login, builder: (context, state) => const LoginPage()),
      GoRoute(path: registerPath, name: register, builder: (context, state) => const RegisterPage()),
      GoRoute(path: mainPath, name: main, builder: (context, state) => const MainPage()),
      GoRoute(path: notificationPath, name: notifications, builder: (context, state) => const NotificationPage()),
      GoRoute(
        path: reservationDetailsPath,
        name: reservationDetails,
        builder: (context, state) => ReservationDetailsPage(reservation: state.extra as ReservationModel),
      ),
      GoRoute(
        path: agenceDetailsPath,
        name: agenceDetails,
        builder: (context, state) => AgenceDetailsPage(agence: state.extra as Agence),
      ),
      GoRoute(path: kwcPath, name: kwc, builder: (context, state) => const KwcPage()),
      GoRoute(path: aboutPath, name: about, builder: (context, state) => const AboutPage()),
      GoRoute(path: faqPath, name: faq, builder: (context, state) => const FaqPage()),
      GoRoute(
        path: bookingPath,
        name: booking,
        builder: (context, state) => BookingPage(voyage: state.extra as VoyageModel),
      ),
      GoRoute(
        path: paymentPath,
        name: payment,
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return PaymentPage(voyage: data['voyage'] as VoyageModel, seat: data['seat'] as String);
        },
      ),
      GoRoute(path: myColisPath, name: myColis, builder: (context, state) => const MyColisPage()),
      GoRoute(
        path: editProfilePath,
        name: editProfile,
        builder: (context, state) => EditProfilePage(user: state.extra as UserModel),
      ),

    ],
  );
}
