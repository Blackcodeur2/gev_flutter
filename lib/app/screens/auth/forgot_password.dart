import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/config/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import 'package:go_router/go_router.dart';
import 'package:camer_trip/l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String? email;
  final String? token;
  const ForgotPasswordScreen({super.key, this.email, this.token});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _codeSent = false;
  bool _obscurePassword = true;
  final _authService = AuthService();

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _animController.forward();

    if (widget.email != null && widget.email!.isNotEmpty) {
      _emailController.text = widget.email!;
    }
    if (widget.token != null && widget.token!.isNotEmpty) {
      _codeController.text = widget.token!;
      _codeSent = true;
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    if (_emailController.text.isEmpty) return;

    setState(() => _isLoading = true);
    final response = await _authService.forgotPassword(_emailController.text);
    setState(() => _isLoading = false);

    if (mounted) {
      if (response.success) {
        setState(() => _codeSent = true);
        _showSnackBar(response.message ?? AppLocalizations.of(context)?.codeSentSuccess ?? "Code envoyé avec succès", isError: false);
      } else {
        _showSnackBar(response.message ?? AppLocalizations.of(context)?.sendCodeError ?? "Erreur lors de l'envoi", isError: true);
      }
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    if (_codeController.text.isEmpty || _passwordController.text.isEmpty) return;

    setState(() => _isLoading = true);
    final response = await _authService.resetPasswordOtp(
      email: _emailController.text,
      code: _codeController.text,
      password: _passwordController.text,
      passwordConfirmation: _confirmPasswordController.text,
    );
    setState(() => _isLoading = false);

    if (mounted) {
      if (response.success) {
        _showSuccessDialog();
      } else {
        _showSnackBar(response.message ?? AppLocalizations.of(context)?.resetError ?? "Erreur de réinitialisation", isError: true);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Icon(Icons.check_circle_outline, color: AppColors.primaryGreen, size: 60),
        content: Text(
          AppLocalizations.of(context)?.resetSuccessMessage ?? "Votre mot de passe a été réinitialisé avec succès. Vous pouvez maintenant vous connecter.",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(AppLocalizations.of(context)?.loginBtn ?? "SE CONNECTER", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
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
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _HeroHeader(isDark: isDark),
              FadeTransition(
                opacity: _fadeAnim,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.largePadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _codeSent ? (localizations?.resetTitle ?? "Réinitialisation") : (localizations?.forgotPasswordTitle ?? "Mot de passe oublié"),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _codeSent 
                          ? (localizations?.enterCodeAndNewPassword ?? "Entrez le code reçu et votre nouveau mot de passe.")
                          : (localizations?.enterEmailForCode ?? "Entrez votre email pour recevoir le code de réinitialisation."),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cs.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      if (!_codeSent) ...[
                        _AppTextField(
                          controller: _emailController,
                          hintText: localizations?.yourEmailAddress ?? "Votre adresse email",
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 32),
                        _ThemedButton(
                          text: localizations?.sendCodeBtn ?? "ENVOYER LE CODE",
                          isLoading: _isLoading,
                          onPressed: _sendResetCode,
                        ),
                      ] else ...[
                        _AppTextField(
                          controller: _codeController,
                          hintText: localizations?.sixDigitCode ?? "Code à 6 chiffres",
                          prefixIcon: Icons.pin_outlined,
                          keyboardType: TextInputType.number,
                        ),
                        const SizedBox(height: 16),
                        _AppTextField(
                          controller: _passwordController,
                          hintText: localizations?.newPassword ?? "Nouveau mot de passe",
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          validator: (v) {
                            if (v == null || v.isEmpty) return localizations?.requiredField ?? 'Requis';
                            if (v.length < 8) return localizations?.min8Chars ?? 'Minimum 8 caractères';
                            return null;
                          },
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _AppTextField(
                          controller: _confirmPasswordController,
                          hintText: localizations?.confirmPassword ?? "Confirmer le mot de passe",
                          prefixIcon: Icons.lock_clock_outlined,
                          obscureText: _obscurePassword,
                          validator: (v) => v != _passwordController.text ? (localizations?.notIdentical ?? 'Non identique') : null,
                        ),
                        const SizedBox(height: 32),
                        _ThemedButton(
                          text: localizations?.resetBtn ?? "RÉINITIALISER",
                          isLoading: _isLoading,
                          onPressed: _resetPassword,
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () => setState(() => _codeSent = false),
                            child: Text(
                              localizations?.changeEmail ?? "Changer d'email",
                              style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ], // Fin de la liste du else ...[
                    ], // Fin de la liste children: [ de la Column (ligne 162)
                  ), // Fin de la Column
                ), // Fin du Form
              ), // Fin du Padding
            ), // Fin du FadeTransition
          ], // Fin de la liste children de la Column principale (ligne 153)
        ), // Fin de la Column principale
      ), // Fin du SingleChildScrollView
    ), // Fin du SafeArea
  ); // Fin du Scaffold
}
}

class _HeroHeader extends StatelessWidget {
  final bool isDark;
  const _HeroHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark 
            ? [const Color(0xFF13231C), AppColors.darkGreen] 
            : [AppColors.primaryGreen, AppColors.lightGreen]
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_reset_rounded, color: Colors.white, size: 60),
                ),
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
  final Widget? suffixIcon;
  final String? Function(String?)? validator;

  const _AppTextField({
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.validator,
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
      style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.3)),
        prefixIcon: Icon(prefixIcon, color: cs.primary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark ? Colors.white.withOpacity(0.05) : AppColors.primaryGreen.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.primary.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
      ),
    );
  }
}

class _ThemedButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback onPressed;

  const _ThemedButton({
    required this.text,
    required this.isLoading,
    required this.onPressed,
  });

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
          : Text(text, style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
      ),
    );
  }
}