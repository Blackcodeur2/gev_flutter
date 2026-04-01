import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData themeClair = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Gestion des couleurs
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryGreen,
      onPrimary: AppColors.primaryWhite,
      secondary: AppColors.primaryRed,
      onSecondary: AppColors.primaryWhite,
      tertiary: AppColors.primaryBlue,
      onTertiary: AppColors.primaryWhite,
      surface: AppColors.lightSurface,
      onSurface: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.primaryWhite,
    ),

    // Gestion de la AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.primaryWhite,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(),
    ),

    //Gestion de la BottomNavigationBar
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightBackground,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showSelectedLabels: true,
    ),

    // Gestion des Cards
    cardTheme: CardThemeData(
      color: AppColors.lightCard,
      elevation: AppConstants.cardElevation,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
    ),

    // Gestion Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.primaryWhite,
        elevation: 2,
        shadowColor: AppColors.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
        textStyle: TextStyle(),
      ),
    ),

    // Gestion Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryBlue,
        textStyle: TextStyle(),
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.textDisabled,
      thickness: 1,
    ),

    textTheme: TextTheme(
      headlineLarge: TextStyle(),
      headlineMedium: TextStyle(),
      headlineSmall: TextStyle(),
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
      bodySmall: TextStyle(),
      titleLarge: TextStyle(),
      titleMedium: TextStyle(),
      titleSmall: TextStyle(),
    ),
  );
  static ThemeData themeSombre = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // Color Scheme
    colorScheme: const ColorScheme.dark(
      primary: AppColors.lightGreen,
      onPrimary: AppColors.darkBackground,
      secondary: AppColors.lightRed,
      onSecondary: AppColors.darkBackground,
      tertiary: AppColors.lightBlue,
      onTertiary: AppColors.darkBackground,
      surface: AppColors.darkSurface,
      onSurface: AppColors.textPrimaryDark,
      error: AppColors.error,
      onError: AppColors.primaryWhite,
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.textPrimaryDark,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(),
      iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
      selectedItemColor: AppColors.lightGreen,
      unselectedItemColor: AppColors.textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      showUnselectedLabels: true,
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.darkCard,
      elevation: AppConstants.cardElevation,
      shadowColor: AppColors.shadowDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightGreen,
        foregroundColor: AppColors.darkBackground,
        elevation: 2,
        shadowColor: AppColors.shadowDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
        textStyle: TextStyle(),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightGreen,
        textStyle: TextStyle(),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkSurface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.textSecondaryDark,
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: const BorderSide(
          color: AppColors.textSecondaryDark,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColors.lightGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        borderSide: const BorderSide(color: AppColors.lightRed, width: 1),
      ),
      labelStyle: TextStyle(),
      hintStyle: TextStyle(),
    ),

    // Text Themes
    textTheme: TextTheme(
      headlineLarge: TextStyle(),
      headlineMedium: TextStyle(),
      headlineSmall: TextStyle(),
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
      bodySmall: TextStyle(),
      titleLarge: TextStyle(),
      titleMedium: TextStyle(),
      titleSmall: TextStyle(),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: AppColors.textPrimaryDark, size: 24),

    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.textDisabledDark,
      thickness: 1,
    ),
  );
}
