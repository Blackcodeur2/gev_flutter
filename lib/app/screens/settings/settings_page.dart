import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:camer_trip/app/config/theme_provider.dart';
import 'package:camer_trip/app/routes/app_routter.dart';
import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: cs.surface,
      body: SafeArea(
        bottom: false, // On laisse le contenu passer sous le bottom bar
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          children: [
            const MyAppBar(title: 'Réglages'),
            
            // 👤 Section Profil Premium
            _buildProfileHeader(cs, isDark),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🎨 Apparence & Personnalisation
                  _buildSectionTitle(cs, 'Apparence & Système'),
                  _buildSettingsCard(cs, isDark, [
                    _buildSwitchTile(
                      cs, 
                      isDark, 
                      Icons.dark_mode_rounded, 
                      'Mode Sombre', 
                      themeProvider.isDark ? 'Activé' : 'Désactivé', 
                      themeProvider.isDark, 
                      (v) => themeProvider.toggleTheme(),
                      Colors.indigo
                    ),
                    _buildSettingsTile(cs, isDark, Icons.language_rounded, 'Langue', 'Français (Cameroun)', Colors.blue),
                    _buildSettingsTile(cs, isDark, Icons.notifications_active_rounded, 'Notifications', 'Alertes et Push', Colors.orange),
                  ]),

                  const SizedBox(height: 24),

                  // 🔐 Sécurité & Données
                  _buildSectionTitle(cs, 'Sécurité'),
                  _buildSettingsCard(cs, isDark, [
                    _buildSettingsTile(
                      cs, 
                      isDark, 
                      Icons.verified_user_rounded, 
                      'Vérification KWC', 
                      'Soumettre ma CNI', 
                      Colors.teal,
                      onTap: () => context.pushNamed(AppRouter.kwc),
                    ),
                    _buildSettingsTile(cs, isDark, Icons.lock_person_rounded, 'Confidentialité', 'Mot de passe et Accès', Colors.cyan),
                  ]),

                  const SizedBox(height: 24),

                  // ❓ Support & Aide
                  _buildSectionTitle(cs, 'Assistance'),
                  _buildSettingsCard(cs, isDark, [
                    _buildSettingsTile(cs, isDark, Icons.help_center_rounded, 'Centre d\'aide', 'Questions fréquentes', Colors.purple),
                    _buildSettingsTile(cs, isDark, Icons.info_outline_rounded, 'À propos', 'v1.4.2 Beta', Colors.grey),
                  ]),

                  const SizedBox(height: 40),

                  // 🚪 Bouton Déconnexion
                  _buildLogoutButton(cs, isDark),
                  
                  const SizedBox(height: 120), // Espace pour la barre flottante
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ColorScheme cs, bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
              ? [cs.primary.withOpacity(0.15), cs.surfaceContainerHigh]
              : [cs.primary, cs.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(isDark ? 0.05 : 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'John Doe',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'john.doe@gmail.com',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('MEMBRE GOLD', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_note_rounded, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(ColorScheme cs, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingsCard(ColorScheme cs, bool isDark, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white10 : cs.primary.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile(ColorScheme cs, bool isDark, IconData icon, String title, String subtitle, Color iconBg, {VoidCallback? onTap}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconBg.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: iconBg, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(color: cs.onSurface.withOpacity(0.4), fontSize: 13)),
      trailing: Icon(Icons.chevron_right_rounded, color: cs.onSurface.withOpacity(0.3)),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile(ColorScheme cs, bool isDark, IconData icon, String title, String subtitle, bool value, Function(bool) onChanged, Color iconBg) {
    return SwitchListTile.adaptive(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      secondary: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconBg.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: iconBg, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      subtitle: Text(subtitle, style: TextStyle(color: cs.onSurface.withOpacity(0.4), fontSize: 13)),
      value: value,
      onChanged: onChanged,
      activeColor: cs.primary,
    );
  }

  Widget _buildLogoutButton(ColorScheme cs, bool isDark) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: cs.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cs.error.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, color: cs.error),
            const SizedBox(width: 12),
            Text(
              'Déconnexion',
              style: TextStyle(color: cs.error, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}