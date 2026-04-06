import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final faqItems = [
      {
        'q': 'Comment effectuer une réservation ?',
        'a': 'Rien de plus simple ! Recherchez un trajet sur la page d\'accueil, sélectionnez le voyage qui vous convient, choisissez votre siège et procédez au paiement via Orange ou MTN Money.',
        'icon': Icons.search_rounded,
      },
      {
        'q': 'Quels sont les moyens de paiement acceptés ?',
        'a': 'Nous acceptons actuellement Orange Money et MTN Mobile Money. Le paiement est sécurisé et immédiat.',
        'icon': Icons.payments_rounded,
      },
      {
        'q': 'Qu\'est-ce que la vérification KWC ?',
        'a': 'Le "Know With CamerTrip" est notre processus de vérification d\'identité. Il est obligatoire pour garantir la sécurité de tous les passagers et se conformer aux réglementations de transport.',
        'icon': Icons.verified_user_rounded,
      },
      {
        'q': 'Puis-je annuler une réservation ?',
        'a': 'Oui, vous pouvez annuler jusqu\'à 24h avant le départ depuis l\'onglet "Billets". Des frais d\'annulation peuvent s\'appliquer selon les politiques de l\'agence.',
        'icon': Icons.cancel_schedule_send_rounded,
      },
      {
        'q': 'Comment récupérer mon ticket après achat ?',
        'a': 'Votre ticket numérique est disponible immédiatement après le paiement dans l\'onglet "Billets". Il contient un QR Code que vous devrez présenter à l\'agence lors de l\'embarquement.',
        'icon': Icons.qr_code_scanner_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            const MyAppBar(title: 'Centre d\'Aide'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    'Questions Fréquentes 🤔',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tout ce qu\'il faut savoir sur CamerTrip.',
                    style: TextStyle(color: cs.onSurface.withOpacity(0.5)),
                  ),
                  const SizedBox(height: 32),
                  ...faqItems.map((item) => _buildFaqItem(context, item, isDark, cs)),
                  const SizedBox(height: 48),
                  
                  // Contact Support
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: cs.primary.withOpacity(0.2)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.support_agent_rounded, size: 48, color: cs.primary),
                        const SizedBox(height: 16),
                        const Text(
                          'Encore besoin d\'aide ?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Notre support client est disponible 24/7 pour vous assister.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: cs.onSurface.withOpacity(0.6)),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.message_rounded),
                            label: const Text('CONTACTER LE SUPPORT'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cs.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildFaqItem(BuildContext context, Map<String, dynamic> item, bool isDark, ColorScheme cs) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.primary.withOpacity(0.05)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item['icon'] as IconData, size: 20, color: cs.primary),
          ),
          title: Text(
            item['q'] as String,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                item['a'] as String,
                style: TextStyle(color: cs.onSurface.withOpacity(0.6), height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
