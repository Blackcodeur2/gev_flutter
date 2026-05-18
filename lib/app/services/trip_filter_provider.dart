import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:camer_trip/app/services/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Provider pour récupérer tous les voyages
final allScheduledTripsProvider = FutureProvider<List<VoyageModel>>((ref) async {
  final voyageService = ref.watch(voyageServiceProvider);
  return await voyageService.getScheduledTrips();
});

// Provider pour l'état du filtre de recherche actuel (par texte)
final tripFilterProvider = StateProvider<String>((ref) => "");

// Provider pour la liste filtrée
final filteredTripsProvider = Provider<AsyncValue<List<VoyageModel>>>((ref) {
  final tripsAsync = ref.watch(allScheduledTripsProvider);
  final query = ref.watch(tripFilterProvider).trim().toLowerCase();

  return tripsAsync.whenData((trips) {
    if (query.isEmpty) {
      return trips;
    }

    return trips.where((trip) {
      final source = (trip.villeSource ?? "").toLowerCase();
      final dest = (trip.villeDestination ?? "").toLowerCase();
      final agence = (trip.nomAgence ?? "").toLowerCase();

      return source.contains(query) || 
             dest.contains(query) || 
             agence.contains(query);
    }).toList();
  });
});
