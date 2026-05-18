import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';

class PaymentPage extends ConsumerStatefulWidget {
  final VoyageModel voyage;
  final String seat;
  const PaymentPage({super.key, required this.voyage, required this.seat});

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  String selectedMethod = 'Orange Money';
  final TextEditingController _phoneController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Préremplir le numéro de téléphone de l'utilisateur actuel
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = await ref.read(currentUserProvider.future);
      if (user != null && user.telephone != null) {
        String phone = user.telephone!;
        if (phone.startsWith('237')) {
          phone = phone.substring(3);
        }
        if (mounted) {
          _phoneController.text = phone;
        }
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    String phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer votre numéro de paiement')),
      );
      return;
    }

    // Formatage du numéro pour CamPay (préfixe 237)
    if (!phone.startsWith('237')) {
      if (phone.length == 9) {
        phone = '237$phone';
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Numéro invalide. Format: 6xx xxx xxx')),
        );
        return;
      }
    }

    setState(() => isLoading = true);

    try {
      final reservationService = ref.read(reservationServiceProvider);
      final paiementService = ref.read(paiementServiceProvider);

      // 1. Créer la réservation (Status: en attente)
      final resResponse = await reservationService.createReservation(
        voyageId: widget.voyage.id!,
        stationId: widget.voyage.stationId,
        place: widget.seat,
        prix: widget.voyage.prix,
        telephonePaiement: phone,
        methodePaiement: selectedMethod,
      );

      if (resResponse == null || (resResponse.statusCode != 200 && resResponse.statusCode != 201)) {
        throw Exception('Erreur lors de la création de la réservation');
      }

      final reservationId = resResponse.data['data']['id'];

      // Invalider l'historique des réservations pour charger la nouvelle réservation 'en attente'
      ref.invalidate(myReservationsProvider);

      // 2. Initier le paiement CamPay
      final payResponse = await paiementService.initiatePayment(
        reservationId: reservationId,
        phone: phone,
      );

      if (payResponse == null || payResponse['statut'] == false) {
        throw Exception(payResponse?['message'] ?? 'Erreur d\'initialisation du paiement');
      }

      final reference = payResponse['reference'];

      // 3. Polling du statut du paiement
      _startPolling(reference);

    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }

  void _startPolling(String reference) async {
    final paiementService = ref.read(paiementServiceProvider);
    int attempts = 0;
    const maxAttempts = 30; // 5 minutes (10s intervalle)

    Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (!mounted || !isLoading) {
        timer.cancel();
        return;
      }
      attempts++;
      if (attempts >= maxAttempts) {
        timer.cancel();
        if (mounted) {
          setState(() => isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Délai de paiement dépassé. Vérifiez vos billets.')),
          );
        }
        return;
      }

      try {
        final status = await paiementService.checkPaymentStatus(reference);
        
        if (status == 'SUCCESSFUL') {
          timer.cancel();
          if (mounted) {
            setState(() => isLoading = false);
            _showSuccessDialog();
          }
        } else if (status == 'FAILED' || status == 'ECHOUÉ') {
          timer.cancel();
          if (mounted) {
            setState(() => isLoading = false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Le paiement a échoué.')),
            );
          }
        }
      } catch (e) {
        // Ignorer les erreurs réseau temporaires pendant le polling
      }
    });
  }


  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Réservation Réussie !',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Votre ticket pour le siège #${widget.seat} est en attente de paiement final. Consultez vos billets pour plus de détails.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ref.invalidate(myReservationsProvider);
                  context.goNamed('main');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('RETOUR À L\'ACCUEIL', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                MyAppBar(title: 'Paiement'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryCard(cs, isDark),

                        const SizedBox(height: 32),
                        const Text('Numéro de paiement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: '6xx xxx xxx',
                            prefixIcon: const Icon(Icons.phone_android),
                            filled: true,
                            fillColor: isDark ? cs.surfaceContainerHigh : Colors.grey[100],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildFooter(cs),
              ],
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(strokeWidth: 4.5),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Validation du Paiement',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Un prompt USSD de paiement a été initié vers le numéro :\n${_phoneController.text.trim()}',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Saisissez votre code PIN sur votre téléphone pour autoriser le débit de ${widget.voyage.prix.toInt()} FCFA.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.sync, color: cs.primary, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Attente du réseau...',
                                  style: TextStyle(color: cs.primary, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Bouton de simulation pour le sandbox
                          TextButton.icon(
                            onPressed: () {
                              setState(() => isLoading = false);
                              _showSuccessDialog();
                            },
                            icon: const Icon(Icons.bug_report, size: 16),
                            label: const Text('Simuler la réussite (Test Sandbox)', style: TextStyle(fontSize: 12)),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.orange[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(ColorScheme cs, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildRow('Trajet', '${widget.voyage.villeSource} - ${widget.voyage.villeDestination}'),
          const Divider(height: 24),
          _buildRow('Siège choisi', '#${widget.seat}'),
          const Divider(height: 24),
          _buildRow('Montant Total', '${widget.voyage.prix.toInt()} FCFA', isBold: true, color: cs.primary),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
              color: color,
              fontSize: isBold ? 18 : 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }


  Widget _buildFooter(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity, height: 56,
        child: ElevatedButton(
          onPressed: isLoading ? null : _handlePayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: cs.primary, foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: isLoading 
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('CONFIRMER LE PAIEMENT', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
