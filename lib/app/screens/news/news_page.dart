import 'package:camer_trip/app/models/annonce_model.dart';
import 'package:camer_trip/app/shared/cards/annonce_card.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:camer_trip/l10n/app_localizations.dart';

class NewsPage extends ConsumerWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    final annoncesAsync = ref.watch(annoncesProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            MyAppBar(title: localizations?.newsTitle ?? 'Nouveautés'),
            Expanded(
              child: annoncesAsync.when(
                data: (annonces) {
                  if (annonces.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () => ref.refresh(annoncesProvider.future),
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        children: [
                          _buildNewsHeader(context, cs, isDark),
                          const SizedBox(height: 48),
                          const Center(
                            child: Text(
                              'Aucune nouveauté pour le moment.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(annoncesProvider.future),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: annonces.length + 1, // +1 pour l'en-tête
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _buildNewsHeader(context, cs, isDark);
                        }
                        final annonce = annonces[index - 1];
                        return AnnonceCard(annonce: annonce);
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => RefreshIndicator(
                  onRefresh: () => ref.refresh(annoncesProvider.future),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    children: [
                      _buildNewsHeader(context, cs, isDark),
                      const SizedBox(height: 48),
                      Center(child: Text('Erreur : $error')),
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

  Widget _buildNewsHeader(BuildContext context, ColorScheme cs, bool isDark) {
    final localizations = AppLocalizations.of(context);
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
                  Text(
                    localizations?.newsHeaderTitle ?? 'Le Journal du Voyageur',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  Text(
                    localizations?.newsHeaderSubtitle ?? 'Dernières actus de vos agences favorites',
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
