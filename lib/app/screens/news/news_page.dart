import 'package:camer_trip/app/models/annonce_model.dart';
import 'package:camer_trip/app/shared/cards/annonce_card.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

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
            const MyAppBar(title: 'Nouveautés'),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: dummyAnnonces.length + 1, // +1 pour l'en-tête de bienvenue
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildNewsHeader(cs, isDark);
                  }
                  final annonce = dummyAnnonces[index - 1];
                  return AnnonceCard(annonce: annonce);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsHeader(ColorScheme cs, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.campaign_rounded, color: Colors.orange, size: 24),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Le Journal du Voyageur',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  Text(
                    'Dernières actus de vos agences favorites',
                    style: TextStyle(fontSize: 12, color: cs.onSurface.withOpacity(0.6)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(thickness: 1, height: 1),
        ],
      ),
    );
  }
}
