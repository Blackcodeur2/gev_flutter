import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'package:camer_trip/l10n/app_localizations.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  final String? id;
  final String? hash;
  const VerifyEmailScreen({super.key, required this.email, this.id, this.hash});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    if (widget.id != null && widget.hash != null) {
      _verifyLink();
    }
  }

  Future<void> _verifyLink() async {
    setState(() => _isLoading = true);
    final response = await _authService.verifyEmailLink(widget.id!, widget.hash!);
    setState(() => _isLoading = false);

    if (mounted) {
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.emailVerifiedViaLink ?? "Email vérifié avec succès via le lien !")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? AppLocalizations.of(context)?.invalidLink ?? "Lien invalide")),
        );
      }
    }
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.length != 6) return;

    setState(() => _isLoading = true);
    final response = await _authService.verifyEmailOtp(widget.email, _codeController.text);
    setState(() => _isLoading = false);

    if (mounted) {
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.emailVerifiedSuccess ?? "Email vérifié avec succès !")),
        );
        // Ici on pourrait rediriger vers la page d'accueil ou de connexion
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message ?? AppLocalizations.of(context)?.invalidCode ?? "Code invalide")),
        );
      }
    }
  }

  Future<void> _resendCode() async {
    setState(() => _isLoading = true);
    final response = await _authService.resendVerificationEmail();
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message ?? AppLocalizations.of(context)?.codeResent ?? "Code renvoyé")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations?.verificationTitle ?? "Vérification"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.green.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.mark_email_read_outlined, size: 80, color: Colors.green),
              const SizedBox(height: 24),
              Text(
                localizations?.checkYourInbox ?? "Vérifiez votre boîte mail",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                localizations?.codeSentMessage(widget.email) ?? "Nous avons envoyé un code de vérification à ${widget.email}. Veuillez l'entrer ci-dessous.",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: localizations?.verificationCodeLabel ?? "Code de vérification",
                  prefixIcon: const Icon(Icons.security),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  hintText: "000000",
                ),
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyCode,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(localizations?.verifyBtn ?? "Vérifier"),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : _resendCode,
                child: Text(localizations?.resendCodeInstructions ?? "Je n'ai pas reçu de code. Renvoyer."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}