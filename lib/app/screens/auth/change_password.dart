import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:camer_trip/l10n/app_localizations.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final authService = ref.read(authServiceProvider);
    final response = await authService.changePassword(
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      newPasswordConfirmation: _confirmPasswordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)?.passwordChangedSuccess ?? "Mot de passe modifié avec succès !"),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message ?? AppLocalizations.of(context)?.passwordChangeError ?? "Erreur lors du changement de mot de passe"),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final userAsync = ref.watch(currentUserProvider);
    final hasPassword = userAsync.value?.hasPassword ?? true;
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(title: localizations?.changePasswordTitle ?? 'Changer le mot de passe'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(cs),
                      const SizedBox(height: 32),
                      
                      if (hasPassword) ...[
                        // Ancien mot de passe
                        _buildPasswordField(
                          label: localizations?.currentPassword ?? 'Mot de passe actuel',
                          controller: _currentPasswordController,
                          obscureText: _obscureCurrent,
                          onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                          validator: (v) => (v == null || v.isEmpty) ? (localizations?.requiredField ?? 'Requis') : null,
                          cs: cs,
                        ),
                        
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 20),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.orange.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, color: Colors.orange),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  localizations?.noPasswordSet ?? "Vous n'avez pas encore de mot de passe défini. Veuillez en créer un pour sécuriser votre compte.",
                                  style: TextStyle(color: cs.onSurface, fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Nouveau mot de passe
                      _buildPasswordField(
                        label: localizations?.newPassword ?? 'Nouveau mot de passe',
                        controller: _newPasswordController,
                        obscureText: _obscureNew,
                        onToggle: () => setState(() => _obscureNew = !_obscureNew),
                        validator: (v) {
                          if (v == null || v.isEmpty) return localizations?.requiredField ?? 'Requis';
                          if (v.length < 8) return localizations?.min8Chars ?? 'Minimum 8 caractères';
                          return null;
                        },
                        cs: cs,
                      ),

                      const SizedBox(height: 20),

                      // Confirmation
                      _buildPasswordField(
                        label: localizations?.confirmNewPassword ?? 'Confirmer le nouveau mot de passe',
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        validator: (v) {
                          if (v != _newPasswordController.text) return localizations?.passwordsDoNotMatch ?? 'Les mots de passe ne correspondent pas';
                          return null;
                        },
                        cs: cs,
                      ),

                      const SizedBox(height: 40),

                      // Bouton de validation
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleChangePassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cs.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  localizations?.updateBtn ?? 'METTRE À JOUR',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
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
    );
  }

  Widget _buildInfoSection(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(Icons.security_rounded, color: cs.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              AppLocalizations.of(context)?.passwordSecurityInfo ?? "Pour des raisons de sécurité, choisissez un mot de passe robuste d'au moins 8 caractères.",
              style: const TextStyle(fontSize: 13, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    required String? Function(String?)? validator,
    required ColorScheme cs,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 20),
              onPressed: onToggle,
            ),
            filled: true,
            fillColor: cs.surfaceContainerHigh,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
