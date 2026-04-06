import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

enum FilterCategory { none, agence, destination, depart, heure }

class TripFilter {
  final FilterCategory category;
  final String value;

  TripFilter({this.category = FilterCategory.none, this.value = ''});

  TripFilter copyWith({FilterCategory? category, String? value}) {
    return TripFilter(
      category: category ?? this.category,
      value: value ?? this.value,
    );
  }
}

// Provider pour récupérer tous les voyages
final allScheduledTripsProvider = FutureProvider<List<VoyageModel>>((ref) async {
  final voyageService = ref.watch(voyageServiceProvider);
  return await voyageService.getScheduledTrips();
});

// Provider pour l'état du filtre actuel (un seul à la fois)
final tripFilterProvider = StateProvider<TripFilter>((ref) => TripFilter());

// Provider pour la liste filtrée
final filteredTripsProvider = Provider<AsyncValue<List<VoyageModel>>>((ref) {
  final tripsAsync = ref.watch(allScheduledTripsProvider);
  final filter = ref.watch(tripFilterProvider);

  return tripsAsync.whenData((trips) {
    if (filter.category == FilterCategory.none || filter.value.isEmpty) {
      return trips;
    }

    return trips.where((trip) {
      switch (filter.category) {
        case FilterCategory.agence:
          return trip.nomAgence == filter.value;
        case FilterCategory.depart:
          return trip.villeSource?.toLowerCase() == filter.value.toLowerCase();
        case FilterCategory.destination:
          return trip.villeDestination?.toLowerCase() == filter.value.toLowerCase();
        case FilterCategory.heure:
          final hour = trip.dateDepart.hour;
          if (filter.value == 'Matin') return hour >= 5 && hour < 12;
          if (filter.value == 'Après-midi') return hour >= 12 && hour < 18;
          if (filter.value == 'Soir') return hour >= 18 || hour < 5;
          return true;
        default:
          return true;
      }
    }).toList();
  });
});
