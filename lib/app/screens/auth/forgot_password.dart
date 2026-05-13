import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _codeSent = false;
  final _authService = AuthService();

  Future<void> _sendResetCode() async {
    if (_emailController.text.isEmpty) return;

    setState(() => _isLoading = true);
    final response = await _authService.forgotPassword(_emailController.text);
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? "Code envoyé")),
      );
      if (response.success) {
        setState(() => _codeSent = true);
      }
    }
  }

  Future<void> _resetPassword() async {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mot de passe réinitialisé avec succès")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? "Erreur")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mot de passe oublié"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_reset, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                _codeSent 
                  ? "Entrez le code reçu par email ainsi que votre nouveau mot de passe."
                  : "Entrez votre adresse email pour recevoir un code de réinitialisation.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              
              if (!_codeSent) ...[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendResetCode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Envoyer le code"),
                ),
              ] else ...[
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: "Code (6 chiffres)",
                    prefixIcon: const Icon(Icons.numbers),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Nouveau mot de passe",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: "Confirmer le mot de passe",
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Réinitialiser le mot de passe"),
                ),
                TextButton(
                  onPressed: () => setState(() => _codeSent = false),
                  child: const Text("Changer d'email"),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}