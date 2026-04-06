import 'dart:ui';

import 'package:camer_trip/app/screens/assistant/chatbot_page.dart';
import 'package:camer_trip/app/screens/history/reservation_page.dart';
import 'package:camer_trip/app/screens/home/home_page.dart';
import 'package:camer_trip/app/screens/news/news_page.dart'; // Import de la nouvelle page
import 'package:camer_trip/app/screens/settings/settings_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    NewsPage(), // Remplacement de Recherche par NewsPage
    ChatBotPage(),
    ReservationsPages(),
    SettingPage()
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBody: true, // Crucial pour que le contenu passe sous la barre flottante
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildPremiumBottomBar(cs, isDark, theme),
    );
  }

  Widget _buildPremiumBottomBar(ColorScheme cs, bool isDark, ThemeData theme) {
    return Container(
      height: 85,
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: isDark 
                  ? cs.surfaceContainerHigh.withOpacity(0.7) 
                  : Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isDark 
                    ? Colors.white.withOpacity(0.1) 
                    : cs.primary.withOpacity(0.1),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Indicateur Animé (Curseur)
                AnimatedAlign(
                  duration: const Duration(milliseconds: 350),
                  curve: Curves.elasticOut,
                  alignment: Alignment(
                    -1.0 + (_currentIndex * 0.5), // Calcul de la position horizontale (-1.0 à 1.0 sur 5 items)
                    0.85, // Position verticale fixe en bas
                  ),
                  child: FractionallySizedBox(
                    widthFactor: 0.2, // 1/5ème de la largeur
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: cs.primary.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Éléments de Navigation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Accueil'),
                    _buildNavItem(1, Icons.newspaper_outlined, Icons.newspaper_outlined, 'Nouveautés'),
                    _buildAssistantItem(cs, 'Assistant'), 
                    _buildNavItem(3, Icons.history_rounded, Icons.history_outlined, 'Billets'),
                    _buildNavItem(4, Icons.settings_rounded, Icons.settings_outlined, 'Profil'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = _currentIndex == index;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isSelected ? activeIcon : inactiveIcon,
                color: isSelected ? cs.primary : cs.onSurface.withOpacity(0.4),
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? cs.primary : cs.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssistantItem(ColorScheme cs, String label) {
    const int index = 2;
    final isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: isSelected 
                  ? LinearGradient(colors: [cs.primary, cs.primary.withOpacity(0.8)])
                  : null,
                color: isSelected ? null : cs.primary.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: cs.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ] : null,
              ),
              child: Icon(
                Icons.auto_awesome_rounded,
                color: isSelected ? Colors.white : cs.primary,
                size: 20,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? cs.primary : cs.onSurface.withOpacity(0.4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
