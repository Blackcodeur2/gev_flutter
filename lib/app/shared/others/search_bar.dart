import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/const_config.dart';
import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;

        return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.largePadding,
        vertical: 8,
      ),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.darkCard
              : AppColors.primaryGreen.withOpacity(0.06),
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          border: Border.all(
            color: isDark
                ? AppColors.textDisabledDark.withOpacity(0.2)
                : AppColors.primaryGreen.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 14),
            Icon(Icons.search_rounded, color: cs.primary, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Chercher une destination...',
                style: TextStyle(
                  color: cs.onSurface.withOpacity(0.4),
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Rechercher',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}