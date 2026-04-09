import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:dio/dio.dart';
import 'api_client_service.dart';

class VoyageService {
  final Dio dio = ApiClient().dio;

  Future<List<VoyageModel>> getScheduledTrips() async {
    try {
      final response = await dio.get('/client/voyages');
      final List<dynamic> data = response.data["data"];
      
      return data.map((json) {
        return VoyageModel(
          id: json['id'],
          numVoyage: json['numVoyage'] ?? '',
          trajetId: json['trajet']?['id'] ?? 0,
          busId: json['bus']?['id'] ?? 0,
          dateDepart: DateTime.parse(json['date_depart']),
          prix: double.parse((json['trajet']?['prix'] ?? 0).toString()),
          chauffeurId: 0,
          statut: json['statut'] ?? 'PROGRAMMÉ',
          gareId: json['gare']?['id'] ?? 0,
          nbPlaces: json['bus']?['nb_places'] ?? 44,
          nomAgence: json['gare']?['agence']?['nom'] ?? 'Inconnu',
          villeSource: json['trajet']?['depart']?['nom'] ?? json['trajet']?['depart']?['ville'] ?? '...',
          villeDestination: json['trajet']?['arrivee']?['nom'] ?? json['trajet']?['arrivee']?['ville'] ?? '...',
        );
      }).toList();
    } catch (e) {
      print("Erreur getScheduledTrips : \$e");
      return [];
    }
  }
}
