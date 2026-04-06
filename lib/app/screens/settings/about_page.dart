import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        child: Column(
          children: [
            const MyAppBar(title: 'À propos'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Logo & Version
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: cs.primary.withOpacity(0.2), width: 2),
                      ),
                      child: Icon(Icons.directions_bus_rounded, color: cs.primary, size: 50),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'CamerTrip',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                      ),
                    ),
                    Text(
                      'Version 1.4.2 Beta',
                      style: TextStyle(color: cs.onSurface.withOpacity(0.5)),
                    ),
                    const SizedBox(height: 48),

                    // Mission Section
                    _buildAboutSection(
                      context,
                      'Notre Mission 🚀',
                      'Simplifier la vie des voyageurs au Cameroun en offrant une plateforme de réservation de bus intuitive, sécurisée et rapide. Plus besoin de faire la queue pendant des heures !',
                    ),
                    const SizedBox(height: 32),

                    // Vision Section
                    _buildAboutSection(
                      context,
                      'Notre Vision 🌍',
                      'Devenir le leader de la mobilité digitale au Cameroun et en Afrique centrale, en connectant toutes les agences de transport à travers une interface unique et premium.',
                    ),
                    const SizedBox(height: 32),

                    // Copyright
                    const Divider(),
                    const SizedBox(height: 24),
                    Text(
                      '© 2024 Blackcodeur IT Solutions\nFait avec ❤️ au Cameroun',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(0.4),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context, String title, String content) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: cs.onSurface.withOpacity(0.7),
              height: 1.6,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
