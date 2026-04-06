import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/config/theme_provider.dart';
import 'package:camer_trip/app/routes/app_routter.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/shared/buttons/theme_toogle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _cniController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // State
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _acceptTerms = false;
  bool _isLoading = false;
  DateTime? _selectedDate;

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
    _nomController.dispose();
    _prenomController.dispose();
    _cniController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ─── Actions ──────────────────────────────────────────────────────────────

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Veuillez accepter les conditions d\'utilisation'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    final authService = ref.read(authServiceProvider);
    final response = await authService.register(
      nom: _nomController.text.trim(),
      prenom: _prenomController.text.trim(),
      numCni: _cniController.text.trim(),
      email: _emailController.text.trim(),
      telephone: _phoneController.text.trim(),
      dateNaissance: _birthDateController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response.success) {
      AppRouter.setLoggedIn(true);
      context.go('/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur : ${response.message}"),
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
                                    'Inscription',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: cs.onSurface,
                                      letterSpacing: -1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Complétez vos informations 🚀',
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

                          const SizedBox(height: 28),

                          // ── Identité ─────────────────────────────────
                          _buildSectionTitle(context, 'Identité'),
                          const SizedBox(height: 16),
                          
                          Row(
                            children: [
                              Expanded(
                                child: _AppTextField(
                                  controller: _nomController,
                                  hintText: 'Nom',
                                  prefixIcon: Icons.person_outline_rounded,
                                  validator: (v) => v!.isEmpty ? 'Requis' : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _AppTextField(
                                  controller: _prenomController,
                                  hintText: 'Prénom',
                                  prefixIcon: Icons.person_outline_rounded,
                                  validator: (v) => v!.isEmpty ? 'Requis' : null,
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 16),
                          
                          _AppTextField(
                            controller: _cniController,
                            hintText: 'Numéro de CNI',
                            prefixIcon: Icons.badge_rounded,
                            keyboardType: TextInputType.number,
                            validator: (v) => v!.isEmpty ? 'Numéro CNI requis' : null,
                          ),

                          const SizedBox(height: 16),
                          
                          // Date picker field
                          GestureDetector(
                            onTap: () => _selectDate(context),
                            child: AbsorbPointer(
                              child: _AppTextField(
                                controller: _birthDateController,
                                hintText: 'Date de naissance',
                                prefixIcon: Icons.calendar_today_rounded,
                                validator: (v) => v!.isEmpty ? 'Date requise' : null,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // ── Contact ──────────────────────────────────
                          _buildSectionTitle(context, 'Contact'),
                          const SizedBox(height: 16),
                          
                          _AppTextField(
                            controller: _emailController,
                            hintText: 'Email',
                            prefixIcon: Icons.email_rounded,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Email requis';
                              if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(v)) return 'Format invalide';
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 16),
                          
                          _AppTextField(
                            controller: _phoneController,
                            hintText: 'Téléphone',
                            prefixIcon: Icons.phone_rounded,
                            keyboardType: TextInputType.phone,
                            validator: (v) => v!.isEmpty ? 'Téléphone requis' : null,
                          ),

                          const SizedBox(height: 28),

                          // ── Sécurité ─────────────────────────────────
                          _buildSectionTitle(context, 'Sécurité'),
                          const SizedBox(height: 16),
                          
                          _AppTextField(
                            controller: _passwordController,
                            hintText: 'Mot de passe',
                            prefixIcon: Icons.lock_rounded,
                            obscureText: _obscurePassword,
                            validator: (v) => v!.length < 8 ? 'Min. 8 caractères' : null,
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 20),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),

                          const SizedBox(height: 16),
                          
                          _AppTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Confirmer',
                            prefixIcon: Icons.lock_clock_rounded,
                            obscureText: _obscureConfirm,
                            validator: (v) => v != _passwordController.text ? 'Non identique' : null,
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirm ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 20),
                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                          ),

                          const SizedBox(height: 12),
                          _PasswordStrengthIndicator(password: _passwordController.text),

                          const SizedBox(height: 32),

                          // ── Accepter CGU ──────────────────────────────
                          _buildTermsCheckbox(context),

                          const SizedBox(height: 32),

                          // ── Bouton S'inscrire ─────────────────────────
                          _RegisterButton(
                            isLoading: _isLoading,
                            onPressed: _handleRegister,
                          ),

                          const SizedBox(height: 40),

                          // ── Lien connexion ────────────────────────────
                          _buildLoginLink(context, cs),

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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTermsCheckbox(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22, height: 22,
          child: Checkbox(
            value: _acceptTerms,
            onChanged: (v) => setState(() => _acceptTerms = v ?? false),
            activeColor: cs.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            "J'accepte les conditions d'utilisation et la politique de confidentialité.",
            style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.6)),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink(BuildContext context, ColorScheme cs) {
    return Center(
      child: GestureDetector(
        onTap: () => context.pop(),
        child: RichText(
          text: TextSpan(
            text: 'Déjà un compte ? ',
            style: TextStyle(color: cs.onSurface.withOpacity(0.55)),
            children: [
              TextSpan(
                text: 'Se connecter',
                style: TextStyle(color: cs.primary, fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════════════════
// Sous-widgets (Classes privées pour la clarté)
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
    final colors = [AppColors.error, AppColors.warning, AppColors.primaryBlue, AppColors.primaryGreen];
    final labels = ['Très faible', 'Faible', 'Moyen', 'Fort'];
    final i = (strength - 1).clamp(0, 3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (index) => Expanded(
            child: Container(
              height: 4, margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: index < strength ? colors[i] : Colors.grey.withOpacity(0.2),
              ),
            ),
          )),
        ),
        const SizedBox(height: 6),
        Text(labels[i], style: TextStyle(color: colors[i], fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _HeroHeader extends StatelessWidget {
  final bool isDark;
  const _HeroHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180, width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
            ? [const Color(0xFF13231C), AppColors.darkGreen] 
            : [AppColors.primaryGreen, AppColors.lightGreen]
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 40, left: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Icon(Icons.person_add_rounded, color: Colors.white, size: 50),
                const SizedBox(height: 10),
                const Text('CRÉER UN COMPTE', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
      style: TextStyle(color: cs.onSurface, fontSize: 14, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.3), fontSize: 14),
        prefixIcon: Icon(prefixIcon, color: cs.primary, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : AppColors.primaryGreen.withOpacity(0.03),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.primary.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: cs.primary, width: 2)),
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  const _RegisterButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
        ),
        child: isLoading 
          ? const CircularProgressIndicator(color: Colors.white) 
          : const Text('CRÉER MON COMPTE', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
      ),
    );
  }
}
