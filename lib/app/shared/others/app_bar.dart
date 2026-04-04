import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/theme_provider.dart';
import 'package:camer_trip/app/shared/buttons/notification_button.dart';
import 'package:camer_trip/app/shared/buttons/theme_toogle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyAppBar extends StatelessWidget {
  final bool isHome;
  final String title;

  const MyAppBar({
    super.key,
    this.isHome = false,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;
    final themeProvider = context.watch<ThemeProvider>();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark 
            ? cs.surfaceContainerHigh.withOpacity(0.8) 
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark 
              ? Colors.white.withOpacity(0.05) 
              : cs.primary.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar + salutation OU Titre Section
          Expanded(
            child: isHome
                ? Row(
                    children: [
                      // Avatar
                      Container(
                        width: 40,
                        height: 40,
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
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bonjour 👋',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: cs.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            'Voyageur',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: cs.onSurface,
                        letterSpacing: 0.5,
                      ),
                    ),
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
