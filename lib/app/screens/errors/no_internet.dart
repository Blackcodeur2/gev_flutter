import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class NoInternetPage extends StatefulWidget {
  final VoidCallback? onRetry;
  const NoInternetPage({super.key, this.onRetry});

  @override
  State<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends State<NoInternetPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnim = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Animated icon ──────────────────────────────────────────
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) => ScaleTransition(
                    scale: _pulseAnim,
                    child: child,
                  ),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: isDark
                            ? [
                                cs.error.withOpacity(0.2),
                                cs.error.withOpacity(0.05),
                              ]
                            : [
                                cs.error.withOpacity(0.15),
                                cs.error.withOpacity(0.03),
                              ],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: cs.error.withOpacity(0.12),
                          border: Border.all(
                            color: cs.error.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.wifi_off_rounded,
                          size: 44,
                          color: cs.error,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Decorative wave lines ──────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    return AnimatedBuilder(
                      animation: _controller,
                      builder: (_, __) {
                        final opacity =
                            (0.3 + 0.5 * _controller.value * (i + 1) / 3)
                                .clamp(0.2, 0.8);
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: 6 + i * 4.0,
                          height: 6 + i * 4.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: cs.error.withOpacity(opacity),
                          ),
                        );
                      },
                    );
                  }),
                ),

                const SizedBox(height: 32),

                // ── Title ──────────────────────────────────────────────────
                Text(
                  localizations?.noInternetTitle ?? 'Pas de connexion',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: cs.onSurface,
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // ── Message ────────────────────────────────────────────────
                Text(
                  localizations?.noInternetMessage ??
                      'Vérifiez votre connexion Wi-Fi ou vos données mobiles et réessayez.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: cs.onSurface.withOpacity(0.55),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                // ── Retry button ───────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: widget.onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cs.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 4,
                      shadowColor: cs.primary.withOpacity(0.4),
                    ),
                    icon: const Icon(Icons.refresh_rounded, size: 22),
                    label: Text(
                      localizations?.retryBtn ?? 'Réessayer',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}