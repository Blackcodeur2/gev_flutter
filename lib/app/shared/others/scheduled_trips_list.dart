import 'package:camer_trip/app/services/trip_filter_provider.dart';
import 'package:camer_trip/app/shared/cards/scheduled_trip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduledTripsList extends ConsumerWidget {
  const ScheduledTripsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredTripsAsync = ref.watch(filteredTripsProvider);
    final cs = Theme.of(context).colorScheme;

    return filteredTripsAsync.when(
      data: (trips) {
        if (trips.isEmpty) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded, size: 64, color: cs.primary.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun voyage trouvé',
                    style: TextStyle(color: cs.onSurface.withOpacity(0.5), fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Veuillez modifier vos filtres',
                    style: TextStyle(color: cs.onSurface.withOpacity(0.3), fontSize: 13),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return ScheduledTripCard(voyage: trips[index]);
            },
            childCount: trips.length,
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, s) => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Center(child: Text('Erreur: $e')),
        ),
      ),
    );
  }
}
