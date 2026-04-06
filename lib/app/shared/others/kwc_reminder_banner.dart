import 'package:camer_trip/app/routes/app_routter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class KwcReminderBanner extends StatelessWidget {
  const KwcReminderBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.errorContainer.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.error.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: cs.error.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: cs.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.verified_user_rounded, color: cs.error, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Identité non vérifiée',
                  style: TextStyle(
                    color: cs.onErrorContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Veuillez vérifier votre identité (KWC) pour pouvoir effectuer des réservations.',
                  style: TextStyle(
                    color: cs.onErrorContainer.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => context.pushNamed(AppRouter.kwc),
            style: TextButton.styleFrom(
              backgroundColor: cs.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: const Text('Vérifier', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
