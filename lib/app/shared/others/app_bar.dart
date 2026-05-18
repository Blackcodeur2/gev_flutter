import 'package:camer_trip/app/config/colors_config.dart';
import 'package:camer_trip/app/config/theme_provider.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/shared/buttons/notification_button.dart';
import 'package:camer_trip/app/shared/buttons/theme_toogle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as legacy_provider;

class MyAppBar extends ConsumerWidget {
  final bool isHome;
  final String title;
  final Widget? trailing;
  final bool showActions;

  const MyAppBar({
    super.key,
    this.isHome = false,
    this.title = '',
    this.trailing,
    this.showActions = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final cs = theme.colorScheme;
    final themeProvider = legacy_provider.Provider.of<ThemeProvider>(context);
    final userAsync = ref.watch(currentUserProvider);

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
                      // Avatar dynamique
                      userAsync.when(
                        data: (user) => Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: user?.profilUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(user!.profilUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                            gradient: user?.profilUrl == null
                                ? LinearGradient(
                                    colors: isDark
                                        ? [
                                            AppColors.darkGreen,
                                            AppColors.primaryGreen
                                          ]
                                        : [
                                            AppColors.primaryGreen,
                                            AppColors.lightGreen
                                          ],
                                  )
                                : null,
                          ),
                          child: user?.profilUrl == null
                              ? const Icon(
                                  Icons.person_rounded,
                                  color: Colors.white,
                                  size: 22,
                                )
                              : null,
                        ),
                        loading: () => Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                        ),
                        error: (e, s) => const Icon(Icons.error),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bonjour 👋',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: cs.onSurface.withOpacity(0.6),
                              ),
                            ),
                            userAsync.when(
                              data: (user) => Text(
                                user != null
                                    ? '${user.prenom}'
                                    : 'Voyageur',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: cs.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              loading: () => const SizedBox(
                                  height: 10,
                                  width: 50,
                                  child: LinearProgressIndicator()),
                              error: (e, s) => const Text('Erreur'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      if (!isHome)
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 20),
                          onPressed: () {
                            if (Navigator.of(context).canPop()) {
                              context.pop();
                            } else {
                              context.go('/main');
                            }
                          },
                        ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: cs.onSurface,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),

          if (trailing != null) trailing!,

          if (showActions && trailing == null) ...[
            // Toggle thème
            ThemeToggleButton(
              isDark: isDark,
              onTap: () => themeProvider.toggleTheme(),
            ),
            const SizedBox(width: 4),

            // Notifications
            NotificationButton(),
          ],
        ],
      ),
    );
  }
}

