import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/theme_provider.dart';
import 'package:camer_trip/app/shared/buttons/notification_button.dart';
import 'package:camer_trip/app/shared/buttons/theme_toogle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;
    final themeProvider = context.watch<ThemeProvider>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
      child: Row(
        children: [
          // Avatar + salutation
          Expanded(
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isDark
                          ? [AppColors.darkGreen, AppColors.primaryGreen]
                          : [AppColors.primaryGreen, AppColors.lightGreen],
                    ),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bonjour 👋',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(),
                      ),
                    ),
                    Text(
                      'Voyageur',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Toggle thème
          ThemeToggleButton(
            isDark: isDark,
            onTap: () => themeProvider.toggleTheme(),
          ),
          const SizedBox(width: 4),

          // Notifications
          NotificationButton(),
        ],
      ),
    );
  }
}
