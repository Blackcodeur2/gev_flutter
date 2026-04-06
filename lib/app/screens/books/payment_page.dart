import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';
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
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer votre numéro de paiement')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final service = ref.read(reservationServiceProvider);
      final response = await service.createReservation(
        voyageId: widget.voyage.id!,
        gareId: widget.voyage.gareId,
        place: widget.seat,
        prix: widget.voyage.prix,
        telephonePaiement: _phoneController.text,
        methodePaiement: selectedMethod,
      );

      if (!mounted) return;
      setState(() => isLoading = false);

      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Une erreur est survenue lors de la réservation')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${e.toString()}')),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Center(child: Icon(Icons.check_circle, color: Colors.green, size: 64)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Réservation Réussie !',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.goNamed('main');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('RETOUR À L\'ACCUEIL'),
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
        child: Column(
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
                    const Text('Choisir le mode de paiement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 16),
                    _buildPaymentMethod(cs, isDark, 'Orange Money', 'assets/icons/orange_money.png', Colors.orange),
                    const SizedBox(height: 12),
                    _buildPaymentMethod(cs, isDark, 'MTN Mobile Money', 'assets/icons/mtn_money.png', Colors.yellow[700]!),
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
        Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.w900 : FontWeight.bold, color: color, fontSize: isBold ? 18 : 14)),
      ],
    );
  }

  Widget _buildPaymentMethod(ColorScheme cs, bool isDark, String method, String iconPath, Color brandColor) {
    bool isSelected = selectedMethod == method;
    return InkWell(
      onTap: () => setState(() => selectedMethod = method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? cs.surfaceContainerHigh : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? brandColor : Colors.transparent, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: brandColor, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.payment, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Text(method, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            if (isSelected) Icon(Icons.check_circle, color: brandColor),
          ],
        ),
      ),
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
