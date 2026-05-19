import 'package:camer_trip/app/shared/others/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/models/notification_model.dart';
import 'package:camer_trip/l10n/app_localizations.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({super.key});

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  bool isActionLoading = false;
  
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    final localizations = AppLocalizations.of(context);

    if (difference.inMinutes < 1) {
      return localizations?.justNow ?? "\u00c0 l'instant";
    } else if (difference.inMinutes < 60) {
      return localizations?.minutesAgo(difference.inMinutes) ?? "Il y a ${difference.inMinutes} min";
    } else if (difference.inHours < 24) {
      return localizations?.hoursAgo(difference.inHours) ?? "Il y a ${difference.inHours} h";
    } else if (difference.inDays < 7) {
      return localizations?.daysAgo(difference.inDays) ?? "Il y a ${difference.inDays} j";
    } else {
      return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";
    }
  }

  Future<void> _markAllRead() async {
    setState(() => isActionLoading = true);
    final success = await ref.read(notificationServiceProvider).markAllAsRead();
    if (success) {
      ref.invalidate(myNotificationsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.allNotificationsRead ?? 'Toutes les notifications sont marquées comme lues')),
        );
      }
    }
    if (mounted) {
      setState(() => isActionLoading = false);
    }
  }

  Future<void> _markSingleRead(NotificationModel notification) async {
    if (notification.readAt != null) return;
    await ref.read(notificationServiceProvider).markAsRead(notification.id);
    ref.invalidate(myNotificationsProvider);
  }

  Future<void> _deleteNotification(NotificationModel notification) async {
    final success = await ref.read(notificationServiceProvider).deleteNotification(notification.id);
    if (success) {
      ref.invalidate(myNotificationsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)?.notificationDeleted ?? 'Notification supprimée')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final localizations = AppLocalizations.of(context);
    final notificationsAsync = ref.watch(myNotificationsProvider);

    return Scaffold(
      backgroundColor: cs.surface,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: Column(
            children: [
              MyAppBar(
                title: localizations?.notificationsTitle ?? 'Notifications',
                trailing: notificationsAsync.maybeWhen(
                  data: (notifications) {
                    final hasUnread = notifications.any((n) => n.readAt == null);
                    if (!hasUnread) return const SizedBox.shrink();
                    
                    return isActionLoading 
                      ? const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : TextButton.icon(
                          onPressed: _markAllRead,
                          icon: const Icon(Icons.done_all, size: 18),
                          label: Text(
                            localizations?.markAllRead ?? 'Tout lire',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: cs.primary,
                          ),
                        );
                  },
                  orElse: () => const SizedBox.shrink(),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(myNotificationsProvider);
                  },
                  child: notificationsAsync.when(
                    data: (notifications) {
                      if (notifications.isEmpty) {
                        return _buildEmptyState(cs, theme);
                      }
                      
                      return ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notif = notifications[index];
                          return _buildNotificationCard(notif, cs, theme, isDark);
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: cs.error),
                          const SizedBox(height: 16),
                          Text(localizations?.loadingError(e.toString()) ?? 'Erreur de chargement : $e', textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.invalidate(myNotificationsProvider),
                            child: Text(localizations?.retryBtn ?? 'Réessayer'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme cs, ThemeData theme) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.notifications_none_rounded, size: 64, color: cs.primary),
            ),
            const SizedBox(height: 24),
            Text(
              localizations?.noNotifications ?? 'Aucune Notification',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              localizations?.noNotificationsDesc ?? "Vous \u00eates \u00e0 jour ! Vos alertes de voyage, rappels et rapports d'incidents appara\u00eetront ici.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600], height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationModel notif, ColorScheme cs, ThemeData theme, bool isDark) {
    final isUnread = notif.readAt == null;
    
    IconData iconData;
    Color iconBgColor;
    Color iconColor;
    
    switch (notif.type) {
      case 'INCIDENT':
        iconData = Icons.warning_rounded;
        iconBgColor = Colors.red[50]!;
        iconColor = Colors.red[800]!;
        break;
      case 'TRIP_REMINDER':
        iconData = Icons.directions_bus_rounded;
        iconBgColor = Colors.green[50]!;
        iconColor = Colors.green[800]!;
        break;
      default:
        iconData = Icons.notifications_rounded;
        iconBgColor = cs.primary.withOpacity(0.08);
        iconColor = cs.primary;
        break;
    }

    return Dismissible(
      key: Key('notif_${notif.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24.0),
        decoration: BoxDecoration(
          color: cs.error,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      onDismissed: (direction) {
        _deleteNotification(notif);
      },
      child: GestureDetector(
        onTap: () => _markSingleRead(notif),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12.0),
          decoration: BoxDecoration(
            color: isUnread 
                ? (isDark ? cs.surfaceContainerHigh : Colors.white) 
                : (isDark ? cs.surfaceContainer : Colors.grey[50]),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isUnread 
                  ? cs.primary.withOpacity(0.3) 
                  : cs.outline.withOpacity(0.08),
              width: 1.5,
            ),
            boxShadow: isUnread ? [
              BoxShadow(
                color: cs.primary.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Left accent border for unread
                  if (isUnread)
                    Container(width: 4, color: cs.primary)
                  else
                    Container(width: 4, color: Colors.transparent),
                  
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Type Icon
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : iconBgColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(iconData, color: isDark ? Colors.white70 : iconColor, size: 22),
                          ),
                          const SizedBox(width: 16),
                          
                          // Text Content
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notif.title,
                                        style: TextStyle(
                                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                                          fontSize: 14,
                                          color: isUnread ? cs.onSurface : cs.onSurface.withOpacity(0.7),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _formatRelativeTime(notif.createdAt),
                                      style: TextStyle(
                                        color: cs.onSurface.withOpacity(0.4),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  notif.message,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isUnread 
                                        ? cs.onSurface.withOpacity(0.8) 
                                        : cs.onSurface.withOpacity(0.5),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
