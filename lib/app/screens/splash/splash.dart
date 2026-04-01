import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<double> _logoSlide;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _redirect();
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    super.dispose();
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2200),
      vsync: this,
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _scale = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.65, curve: Curves.elasticOut),
      ),
    );

    _logoSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  Future<void> _redirect() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final isFirstOpen = prefs.getBool('isFirstOpen') ?? true;

    if (isFirstOpen) {
      context.go('/onboarding');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Gradient adapté au thème
    final gradientColors = isDark
        ? [
            const Color(0xFF0D1117),
            const Color(0xFF1A2E25),
            AppColors.darkGreen,
          ]
        : [
            AppColors.primaryGreen,
            AppColors.lightGreen,
            const Color(0xFF9AE6B4),
          ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // ── Cercles décoratifs ────────────────────────────────────
              Positioned(
                top: -60,
                right: -60,
                child: _DecorCircle(
                  size: 200,
                  color: Colors.white.withOpacity(isDark ? 0.03 : 0.10),
                ),
              ),
              Positioned(
                top: 80,
                right: 20,
                child: _DecorCircle(
                  size: 80,
                  color: Colors.white.withOpacity(isDark ? 0.05 : 0.13),
                ),
              ),
              Positioned(
                bottom: -40,
                left: -40,
                child: _DecorCircle(
                  size: 180,
                  color: Colors.white.withOpacity(isDark ? 0.03 : 0.08),
                ),
              ),
              Positioned(
                bottom: 120,
                right: -30,
                child: _DecorCircle(
                  size: 100,
                  color: Colors.white.withOpacity(isDark ? 0.04 : 0.10),
                ),
              ),

              // ── Contenu principal ─────────────────────────────────────
              Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, _) {
                    return FadeTransition(
                      opacity: _fade,
                      child: Transform.translate(
                        offset: Offset(0, _logoSlide.value),
                        child: ScaleTransition(
                          scale: _scale,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Logo
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black
                                          .withOpacity(isDark ? 0.4 : 0.15),
                                      blurRadius: 30,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Image.asset(
                                      'images/ico.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => Icon(
                                        Icons.directions_bus_rounded,
                                        size: 60,
                                        color: AppColors.primaryGreen,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),

                              // Nom de l'app
                              Text(
                                AppConstants.appName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.5,
                                ),
                              ),

                              const SizedBox(height: 8),

                              // Slogan
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '🌍  Voyage facilement au Cameroun',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── Indicateur de chargement en bas ───────────────────────
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                  animation: _fade,
                  builder: (_, __) => FadeTransition(
                    opacity: _fade,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white.withOpacity(0.85),
                            ),
                            strokeWidth: 2.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Chargement...',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  final double size;
  final Color color;
  const _DecorCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
