import 'package:camer_trip/app/config/colors_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationButton extends StatelessWidget {
  const NotificationButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return IconButton(
      onPressed: () {
        context.go('/notifications');
      },
      icon: Stack(
        children: [
          Icon(Icons.notifications_outlined, color: cs.onSurface, size: 26),
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primaryRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
