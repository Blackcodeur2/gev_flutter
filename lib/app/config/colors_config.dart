import 'package:flutter/material.dart';

class AppColors {
  // Couleurs principales basées sur le logo
  static const Color primaryBlue = Color(0xFF2E3192);
  static const Color primaryRed = Color(0xFFE53E3E);
  static const Color primaryGreen = Color(0xFF38A169);
  static const Color primaryWhite = Color(0xFFFFFFFF);
  static const Color primaryGray = Color(0xFF4A5568);

  // Variations des couleurs principales pour thème clair
  static const Color lightBlue = Color(0xFF4C51BF);
  static const Color darkBlue = Color(0xFF1A202C);
  static const Color lightRed = Color(0xFFF56565);
  static const Color darkRed = Color(0xFFC53030);
  static const Color lightGreen = Color(0xFF48BB78);
  static const Color darkGreen = Color(0xFF2F855A);
  static const Color lightGray = Color(0xFF718096);
  static const Color darkGray = Color(0xFF2D3748);

  // Couleurs du thème sombre
  static const Color darkBackground = Color(0xFF0D1117);
  static const Color darkSurface = Color.fromARGB(255, 22, 34, 31);
  static const Color darkCard = Color.fromARGB(255, 33, 45, 40);

  // Couleurs du thème clair
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);

  // Couleurs utilitaires cohérentes avec la charte
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFE53E3E);
  static const Color info = Color(0xFF2E3192);

  // Couleurs de texte
  static const Color textPrimary = Color.fromARGB(255, 21, 25, 33);
  static const Color textSecondary = Color.fromARGB(255, 36, 50, 47);
  static const Color textDisabled = Color(0xFFA0AEC0);
  static const Color textPrimaryDark = Color(
    0xFFF7FAFC,
  ); // Texte principal clair
  static const Color textSecondaryDark = Color(
    0xFFE2E8F0,
  ); // Texte secondaire clair
  static const Color textDisabledDark = Color(
    0xFF718096,
  ); // Texte désactivé sombre

  // Couleurs d'ombrage
  static const Color shadow = Color.fromARGB(26, 46, 146, 116);
  static const Color shadowDark = Color.fromARGB(77, 46, 146, 106);
}
