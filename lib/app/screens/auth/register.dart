import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;
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
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez accepter les conditions d\'utilisation'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2)); // Simule une requête API
    if (!mounted) return;
    setState(() => _isLoading = false);

    context.go('/main');
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
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
                          Text(
                            'Créer un compte',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rejoins des milliers de voyageurs 🚀',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface.withOpacity(0.55),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Nom complet ───────────────────────────────
                          _buildLabel(context, 'Nom complet'),
                          const SizedBox(height: 8),
                          _AppTextField(
                            controller: _nameController,
                            hintText: 'Jean Dupont',
                            prefixIcon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.name,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Veuillez entrer votre nom';
                              }
                              if (v.trim().length < 3) {
                                return 'Minimum 3 caractères';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          // ── Email ─────────────────────────────────────
                          _buildLabel(context, 'Adresse email'),
                          const SizedBox(height: 8),
                          _AppTextField(
                            controller: _emailController,
                            hintText: 'exemple@email.com',
                            prefixIcon: Icons.email_outlined,
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

                          const SizedBox(height: 18),

                          // ── Téléphone ─────────────────────────────────
                          _buildLabel(context, 'Numéro de téléphone'),
                          const SizedBox(height: 8),
                          _AppTextField(
                            controller: _phoneController,
                            hintText: '+237 6XX XXX XXX',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Veuillez entrer votre numéro';
                              }
                              if (v.trim().length < 9) {
                                return 'Numéro invalide';
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 18),

                          // ── Mot de passe ──────────────────────────────
                          _buildLabel(context, 'Mot de passe'),
                          const SizedBox(height: 8),
                          _AppTextField(
                            controller: _passwordController,
                            hintText: '••••••••',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Veuillez entrer un mot de passe';
                              }
                              if (v.length < 8) {
                                return 'Minimum 8 caractères';
                              }
                              if (!RegExp(r'[0-9]').hasMatch(v)) {
                                return 'Doit contenir au moins un chiffre';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: cs.onSurface.withOpacity(0.5),
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ── Confirmer mot de passe ────────────────────
                          _buildLabel(context, 'Confirmer le mot de passe'),
                          const SizedBox(height: 8),
                          _AppTextField(
                            controller: _confirmPasswordController,
                            hintText: '••••••••',
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscureConfirm,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Veuillez confirmer le mot de passe';
                              }
                              if (v != _passwordController.text) {
                                return 'Les mots de passe ne correspondent pas';
                              }
                              return null;
                            },
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: cs.onSurface.withOpacity(0.5),
                                size: 20,
                              ),
                              onPressed: () => setState(
                                () => _obscureConfirm = !_obscureConfirm,
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // ── Indicateur de force mot de passe ──────────
                          _PasswordStrengthIndicator(
                            password: _passwordController.text,
                          ),

                          const SizedBox(height: 16),

                          // ── Accepter CGU ──────────────────────────────
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                  value: _acceptTerms,
                                  onChanged: (v) => setState(
                                    () => _acceptTerms = v ?? false,
                                  ),
                                  activeColor: cs.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    text: "J'accepte les ",
                                    style:
                                        theme.textTheme.bodySmall?.copyWith(
                                      color:
                                          cs.onSurface.withOpacity(0.65),
                                    ),
                                    children: [
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            'Conditions d\'utilisation',
                                            style: TextStyle(
                                              color: cs.primary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      TextSpan(
                                        text: " et la ",
                                        style:
                                            theme.textTheme.bodySmall?.copyWith(
                                          color:
                                              cs.onSurface.withOpacity(0.65),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: Text(
                                            'Politique de confidentialité',
                                            style: TextStyle(
                                              color: cs.primary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // ── Bouton S'inscrire ─────────────────────────
                          _RegisterButton(
                            isLoading: _isLoading,
                            onPressed: _handleRegister,
                          ),

                          const SizedBox(height: 28),

                          // ── Divider Social ────────────────────────────
                          _DividerOr(isDark: isDark),

                          const SizedBox(height: 20),

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
                              const SizedBox(width: 12),
                              Expanded(
                                child: _SocialButton(
                                  label: 'Facebook',
                                  icon: Icons.facebook_rounded,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // ── Lien connexion ────────────────────────────
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Déjà un compte ?  ',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: cs.onSurface.withOpacity(0.55),
                                ),
                                children: [
                                  WidgetSpan(
                                    alignment: PlaceholderAlignment.middle,
                                    child: GestureDetector(
                                      onTap: () => context.go('/login'),
                                      child: Text(
                                        'Se connecter',
                                        style: TextStyle(
                                          color: cs.primary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
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
            fontWeight: FontWeight.w600,
            color:
                Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
          ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Indicateur de force du mot de passe
// ══════════════════════════════════════════════════════════════════════════════
class _PasswordStrengthIndicator extends StatelessWidget {
  final String password;
  const _PasswordStrengthIndicator({required this.password});

  int _getStrength() {
    int score = 0;
    if (password.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    return score;
  }

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = _getStrength();
    final labels = ['Très faible', 'Faible', 'Moyen', 'Fort'];
    final colors = [
      AppColors.error,
      AppColors.warning,
      AppColors.primaryBlue,
      AppColors.primaryGreen,
    ];

    final index = (strength - 1).clamp(0, 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 4),
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: i < strength
                      ? colors[index]
                      : Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Text(
          'Force : ${labels[index]}',
          style: TextStyle(
            fontSize: 11,
            color: colors[index],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Hero Header (identique au login, couleur secondaire)
// ══════════════════════════════════════════════════════════════════════════════
class _HeroHeader extends StatelessWidget {
  final bool isDark;
  const _HeroHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A2E25),
                    AppColors.darkGreen,
                    AppColors.primaryGreen,
                  ]
                : [
                    AppColors.primaryGreen,
                    AppColors.lightGreen,
                    const Color(0xFF9AE6B4),
                  ],
          ),
        ),
        child: Stack(
          children: [
            // Cercles décoratifs
            Positioned(
              top: -30,
              right: -30,
              child: _DecorCircle(
                size: 130,
                color: Colors.white.withOpacity(isDark ? 0.04 : 0.12),
              ),
            ),
            Positioned(
              top: 40,
              right: 60,
              child: _DecorCircle(
                size: 60,
                color: Colors.white.withOpacity(isDark ? 0.06 : 0.15),
              ),
            ),
            Positioned(
              bottom: 50,
              left: -20,
              child: _DecorCircle(
                size: 90,
                color: Colors.white.withOpacity(isDark ? 0.04 : 0.10),
              ),
            ),

            // Bouton retour (positionné en haut à gauche)
            Positioned(
              top: 4,
              left: 4,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => context.go('/login'),
              ),
            ),

            // Contenu centré (icône + textes)
            Positioned.fill(
              bottom: 36,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      color: AppColors.primaryGreen,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Créer un compte',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'CamerTrip — Voyage facilement 🌍',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
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
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height - 20,
    );
    path.quadraticBezierTo(
      size.width * 3 / 4,
      size.height - 40,
      size.width,
      size.height - 10,
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
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: cs.onSurface.withOpacity(0.35),
          fontSize: 14,
        ),
        prefixIcon: Icon(prefixIcon, color: cs.primary, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark
            ? AppColors.darkCard
            : AppColors.primaryGreen.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide(
            color: cs.primary.withOpacity(0.15),
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.textDisabledDark.withOpacity(0.3)
                : AppColors.primaryGreen.withOpacity(0.2),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Bouton S'inscrire
// ══════════════════════════════════════════════════════════════════════════════
class _RegisterButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const _RegisterButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: AppConstants.buttonHeight + 4,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [AppColors.darkGreen, AppColors.primaryGreen]
                : [AppColors.primaryGreen, AppColors.lightGreen],
          ),
          borderRadius:
              BorderRadius.circular(AppConstants.defaultBorderRadius),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_add_alt_1_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Créer mon compte',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Divider "OU"
// ══════════════════════════════════════════════════════════════════════════════
class _DividerOr extends StatelessWidget {
  final bool isDark;
  const _DividerOr({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final dividerColor =
        Theme.of(context).colorScheme.onSurface.withOpacity(0.15);
    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(
            'OU',
            style: TextStyle(
              color:
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Bouton Social
// ══════════════════════════════════════════════════════════════════════════════
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
      icon: Icon(icon, size: 20, color: cs.onSurface.withOpacity(0.7)),
      label: Text(
        label,
        style: TextStyle(
          color: cs.onSurface.withOpacity(0.75),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 13),
        backgroundColor: isDark
            ? AppColors.darkCard
            : AppColors.primaryGreen.withOpacity(0.04),
        side: BorderSide(
          color: isDark
              ? AppColors.textDisabledDark.withOpacity(0.25)
              : AppColors.primaryGreen.withOpacity(0.2),
          width: 1.2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),
    );
  }
}
