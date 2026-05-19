import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camer_trip/l10n/app_localizations.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  void _showSupportDialog(BuildContext context, ColorScheme cs, bool isDark) {
    const Color brandRed = Color(0xFFE53E3E);
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? cs.surfaceContainerHigh : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: brandRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.support_agent_rounded, color: brandRed, size: 24),
            ),
            const SizedBox(width: 12),
            Text(
              localizations?.contactSupport ?? 'Contacter le Support',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations?.contactSupportDesc ?? 'Notre service client est disponible 24h/24 et 7j/7. Cliquez sur un moyen de contact pour le copier.',
              style: TextStyle(color: cs.onSurface.withOpacity(0.6), fontSize: 13),
            ),
            const SizedBox(height: 20),
            _buildContactTile(
              context,
              Icons.phone_rounded,
              localizations?.directCall ?? 'Appel Direct',
              '+237 6 77 77 77 77',
              brandRed,
              cs,
            ),
            const SizedBox(height: 12),
            _buildContactTile(
              context,
              Icons.chat_bubble_outline_rounded,
              localizations?.whatsappSupport ?? 'WhatsApp Support',
              '+237 6 99 99 99 99',
              Colors.green,
              cs,
            ),
            const SizedBox(height: 12),
            _buildContactTile(
              context,
              Icons.email_outlined,
              localizations?.emailAddressLabel ?? 'Adresse E-mail',
              'support@camertrip.com',
              Colors.blue,
              cs,
            ),
            const SizedBox(height: 12),
            _buildContactTile(
              context,
              Icons.auto_awesome_rounded,
              localizations?.aiAssistantLabel ?? 'Assistant IA',
              localizations?.aiAssistantDesc ?? 'Disponible via l\'onglet Assistant',
              brandRed,
              cs,
              isCopyable: false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(localizations?.closeBtn ?? 'FERMER', style: const TextStyle(fontWeight: FontWeight.bold, color: brandRed)),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
    ColorScheme cs, {
    bool isCopyable = true,
  }) {
    final localizations = AppLocalizations.of(context);
    return InkWell(
      onTap: () {
        if (isCopyable) {
          Clipboard.setData(ClipboardData(text: value));
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations?.copiedToClipboard(label) ?? '$label copié dans le presse-papiers !'),
              backgroundColor: const Color(0xFFE53E3E),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: cs.onSurface.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: cs.onSurface.withOpacity(0.5)),
                  ),
                  Text(
                    value,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: cs.onSurface),
                  ),
                ],
              ),
            ),
            if (isCopyable)
              Icon(Icons.copy_rounded, size: 16, color: cs.onSurface.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    const Color brandRed = Color(0xFFE53E3E);
    final localizations = AppLocalizations.of(context);

    final faqItems = [
      {
        'q': localizations?.faqQ1 ?? 'Comment effectuer une réservation ?',
        'a': localizations?.faqA1 ?? 'Recherchez un trajet sur la page d\'accueil, sélectionnez le voyage qui vous convient, choisissez votre siège et procédez au paiement via Orange Money ou MTN Mobile Money.',
        'icon': Icons.search_rounded,
      },
      {
        'q': localizations?.faqQ2 ?? 'Quels sont les moyens de paiement acceptés ?',
        'a': localizations?.faqA2 ?? 'Nous acceptons Orange Money (OM) et MTN Mobile Money (MoMo). Les paiements sont entièrement sécurisés, cryptés et traités instantanément.',
        'icon': Icons.payments_rounded,
      },
      {
        'q': localizations?.faqQ3 ?? 'Pas de code USSD reçu lors du paiement ?',
        'a': localizations?.faqA3 ?? 'Si la fenêtre de confirmation USSD ne s\'affiche pas automatiquement, pas d\'inquiétude ! Composez manuellement le code de secours de votre opérateur (*126# pour MTN ou #150*4*4# pour Orange) afin d\'autoriser la transaction dans les minutes qui suivent.',
        'icon': Icons.sms_failed_rounded,
      },
      {
        'q': localizations?.faqQ4 ?? 'Combien de temps avant le départ à la gare ?',
        'a': localizations?.faqA4 ?? 'Nous vous conseillons vivement de vous présenter à la gare d\'embarquement au moins 45 minutes avant l\'heure de départ afin de procéder à l\'enregistrement des bagages et à la validation de votre billet numérique.',
        'icon': Icons.alarm_rounded,
      },
      {
        'q': localizations?.faqQ5 ?? 'Comment récupérer mon ticket après l\'achat ?',
        'a': localizations?.faqA5 ?? 'Votre ticket numérique est généré instantanément après validation du paiement. Vous le retrouverez dans l\'onglet "Billets" sous forme de QR Code que vous présenterez au guichet d\'embarquement.',
        'icon': Icons.qr_code_scanner_rounded,
      },
      {
        'q': localizations?.faqQ6 ?? 'Puis-je annuler ou reporter un voyage ?',
        'a': localizations?.faqA6 ?? 'Vous pouvez annuler ou demander un report jusqu\'à 24 heures avant le départ depuis les détails de votre réservation dans l\'onglet "Billets". Des frais d\'annulation minimes peuvent être retenus par l\'agence.',
        'icon': Icons.cancel_schedule_send_rounded,
      },
    ];

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(title: localizations?.helpCenter ?? 'Centre d\'Aide'),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    localizations?.faqTitle ?? 'Questions Fréquentes 🤔',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localizations?.faqSubtitle ?? 'Tout ce qu\'il faut savoir sur CamerTrip / GEV.',
                    style: TextStyle(color: cs.onSurface.withOpacity(0.5)),
                  ),
                  const SizedBox(height: 24),
                  ...faqItems.map((item) => _buildFaqItem(context, item, isDark, cs, brandRed)),
                  const SizedBox(height: 36),
                  
                  // Contact Support
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: brandRed.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: brandRed.withOpacity(0.15)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: brandRed.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.support_agent_rounded, size: 36, color: brandRed),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations?.stillNeedHelp ?? 'Encore besoin d\'aide ?',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations?.supportAvailabilityDesc ?? 'Notre équipe de support client est disponible 24/7 pour vous assister à tout moment.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: cs.onSurface.withOpacity(0.6), height: 1.4),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showSupportDialog(context, cs, isDark),
                            icon: const Icon(Icons.message_rounded),
                            label: Text(localizations?.contactSupportBtn ?? 'CONTACTER LE SUPPORT'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandRed,
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

  Widget _buildFaqItem(BuildContext context, Map<String, dynamic> item, bool isDark, ColorScheme cs, Color brandColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: brandColor.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.1 : 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          shape: const RoundedRectangleBorder(side: BorderSide.none),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: brandColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item['icon'] as IconData, size: 20, color: brandColor),
          ),
          title: Text(
            item['q'] as String,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                item['a'] as String,
                style: TextStyle(color: cs.onSurface.withOpacity(0.65), height: 1.5, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
