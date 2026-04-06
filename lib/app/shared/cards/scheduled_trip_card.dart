import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:camer_trip/app/shared/others/kwc_restriction_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ScheduledTripCard extends ConsumerWidget {
  final VoyageModel voyage;
  final VoidCallback? onTap;

  const ScheduledTripCard({super.key, required this.voyage, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    
    final userAsync = ref.watch(currentUserProvider);
    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd MMM');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? cs.surfaceContainerHigh : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            userAsync.whenData((user) {
              if (user?.statut == "en attente") {
                KwcRestrictionDialog.show(context);
              } else {
                if (onTap != null) {
                  onTap!();
                } else {
                  // Par défaut, si pas de callback, on peut imaginer une navigation
                  // context.pushNamed('voyageDetails', extra: voyage);
                }
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Agence Info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.directions_bus_rounded, color: cs.primary, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          voyage.nomAgence ?? "Agence",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    // Prix
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '${voyage.prix.toInt()} FCFA',
                        style: TextStyle(color: cs.onSecondaryContainer, fontWeight: FontWeight.bold, fontSize: 8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Route info
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timeFormat.format(voyage.dateDepart),
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                        Text(
                          dateFormat.format(voyage.dateDepart),
                          style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.circle_outlined, size: 10, color: cs.primary),
                          Expanded(child: Divider(color: cs.primary.withOpacity(0.2), indent: 4, endIndent: 4)),
                          Icon(Icons.location_on, size: 16, color: cs.primary),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${voyage.villeSource} → ${voyage.villeDestination}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Statut: ${voyage.statut}',
                            style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
