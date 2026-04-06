import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/config/theme_provider.dart';
import 'package:camer_trip/app/routes/app_routter.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/shared/buttons/theme_toogle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // State
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  // Animation
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Actions ─────────────────────────────────────────────────────────────

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;
    setState(() => _isLoading = true);
    final authService = ref.read(authServiceProvider);
    final response = await authService.login(
      _emailController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response.success == true) {
      AppRouter.setLoggedIn(true);
      context.go('/main');
    } else {
      final String msg = response.message ?? "Erreur inconnue";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : $msg"),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
        ),
      );
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // ── Header / Hero ──────────────────────────────────────────
              _HeroHeader(isDark: isDark),

              // ── Formulaire animé ───────────────────────────────────────
              FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.largePadding,
                      vertical: 8,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Connexion',
                                    style: theme.textTheme.headlineSmall
                                        ?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: cs.onSurface,
                                          letterSpacing: -1.0,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Bon retour 👋 Heureux de te revoir.',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: cs.onSurface.withOpacity(0.55),
                                    ),
                                  ),
                                ],
                              ),
                              ThemeToggleButton(
                                isDark: isDark,
                                onTap: () => themeProvider.toggleTheme(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // ── Champ Email ───────────────────────────────
                          _buildLabel(context, 'Adresse email'),
                          const SizedBox(height: 10),
                          _AppTextField(
                            controller: _emailController,
                            hintText: 'exemple@email.com',
                            prefixIcon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Veuillez entrer votre email';
                              }
                              if (!RegExp(
                                r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$',
                              ).hasMatch(v)) {
                                return 'Email invalide';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 20),

                          // ── Champ Mot de passe ────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildLabel(context, 'Mot de passe'),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Mot de passe oublié ?',
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _AppTextField(
                            controller: _passwordController,
                            hintText: '••••••••',
                            prefixIcon: Icons.lock_rounded,
                            obscureText: _obscurePassword,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Veuillez entrer votre mot de passe';
                              }
                              if (v.length < 6) {
                                return 'Minimum 6 caractères';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_rounded
                                    : Icons.visibility_rounded,
                                color: cs.primary.withOpacity(0.5),
                                size: 22,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── Se souvenir de moi ────────────────────────
                          Row(
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: _rememberMe,
                                  onChanged: (v) =>
                                      setState(() => _rememberMe = v ?? false),
                                  activeColor: cs.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Se souvenir de moi',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurface.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // ── Bouton Se connecter ───────────────────────
                          _LoginButton(
                            isLoading: _isLoading,
                            onPressed: _handleLogin,
                          ),

                          const SizedBox(height: 32),

                          // ── Divider Social ────────────────────────────
                          _DividerOr(isDark: isDark),

                          const SizedBox(height: 24),

                          // ── Boutons sociaux ───────────────────────────
                          Row(
                            children: [
                              Expanded(
                                child: _SocialButton(
                                  label: 'Google',
                                  icon: Icons.g_mobiledata_rounded,
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _SocialButton(
                                  label: 'Facebook',
                                  icon: Icons.facebook_rounded,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // ── Lien inscription ──────────────────────────
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: "Pas encore de compte ? ",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurface.withOpacity(0.55),
                                ),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: GestureDetector(
                                      onTap: () => context.push('/register'),
                                      child: Text(
                                        "S'inscrire",
                                        style: TextStyle(
                                          color: cs.primary,
                                          fontWeight: FontWeight.w800,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
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

  Widget _buildLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
        letterSpacing: 0.2,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Hero Header
// ══════════════════════════════════════════════════════════════════════════════
class _HeroHeader extends StatelessWidget {
  final bool isDark;
  const _HeroHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        height: 280,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF13231C),
                    AppColors.darkGreen,
                    AppColors.primaryGreen,
                  ]
                : [
                    AppColors.primaryGreen,
                    AppColors.lightGreen,
                    const Color(0xFFB0F2C2),
                  ],
          ),
        ),
        child: Stack(
          children: [
            // Cercles décoratifs avec animation subtile
            Positioned(
              top: -40,
              right: -40,
              child: _DecorCircle(
                size: 160,
                color: Colors.white.withOpacity(isDark ? 0.05 : 0.15),
              ),
            ),
            Positioned(
              top: 60,
              right: 80,
              child: _DecorCircle(
                size: 70,
                color: Colors.white.withOpacity(isDark ? 0.08 : 0.18),
              ),
            ),
            Positioned(
              bottom: 60,
              left: -30,
              child: _DecorCircle(
                size: 110,
                color: Colors.white.withOpacity(isDark ? 0.05 : 0.12),
              ),
            ),

            // Contenu centré
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo container avec effet de flottement
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(seconds: 2),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 4 * (1 - (value * 2 - 1).abs())),
                          child: child,
                        );
                      },
                      child: Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Image.asset(
                              'images/logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.directions_bus_rounded,
                                size: 44,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      AppConstants.appName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Voyagez malin au Cameroun 🌍',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 25,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height - 50,
      size.width,
      size.height - 15,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_WaveClipper oldClipper) => false;
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

// ══════════════════════════════════════════════════════════════════════════════
// Champ de texte personnalisé
// ══════════════════════════════════════════════════════════════════════════════
class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const _AppTextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        color: cs.onSurface,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: cs.onSurface.withOpacity(0.3),
          fontSize: 15,
        ),
        prefixIcon: Icon(prefixIcon, color: cs.primary, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark
            ? AppColors.darkCard.withOpacity(0.7)
            : AppColors.primaryGreen.withOpacity(0.04),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : AppColors.primaryGreen.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Bouton de connexion
// ══════════════════════════════════════════════════════════════════════════════
class _LoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const _LoginButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 58,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.darkGreen, AppColors.primaryGreen]
                : [AppColors.primaryGreen, AppColors.lightGreen],
          ),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppConstants.defaultBorderRadius,
              ),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'SE CONNECTER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(
                      Icons.login_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _DividerOr extends StatelessWidget {
  final bool isDark;
  const _DividerOr({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final dividerColor = Theme.of(
      context,
    ).colorScheme.onSurface.withOpacity(0.1);
    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor, thickness: 1.5)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OU CONTINUER AVEC',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor, thickness: 1.5)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 24, color: cs.onSurface.withOpacity(0.8)),
      label: Text(
        label,
        style: TextStyle(
          color: cs.onSurface.withOpacity(0.8),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: isDark
            ? AppColors.darkCard.withOpacity(0.4)
            : Colors.white,
        side: BorderSide(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.08),
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
    );
  }
}
