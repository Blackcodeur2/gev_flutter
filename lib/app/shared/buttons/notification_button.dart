import 'package:camer_trip/app/config/colors_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:camer_trip/app/services/providers.dart';

class NotificationButton extends ConsumerWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    
    final notificationsAsync = ref.watch(myNotificationsProvider);

    return IconButton(
      onPressed: () {
        context.push('/notifications');
      },
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(Icons.notifications_outlined, color: cs.onSurface, size: 26),
          notificationsAsync.maybeWhen(
            data: (notifications) {
              final unreadCount = notifications.where((n) => n.readAt == null).length;
              if (unreadCount == 0) return const SizedBox.shrink();
              
              return Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Center(
                    child: Text(
                      unreadCount > 9 ? '9+' : '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
