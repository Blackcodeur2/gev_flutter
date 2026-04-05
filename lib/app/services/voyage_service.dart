import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:dio/dio.dart';
import 'api_client_service.dart';

class VoyageService {
  final Dio dio = ApiClient().dio;

  Future<List<dynamic>> getPromoTrips() async {
    try {
      final response = await dio.get('/client/promo-trips');
      return response.data["data"];
    } catch (e) {
      print("Erreur promosTrips $e");
      return [];
    }
  }

  // Simulation des voyages programmés en attendant la route API
  Future<List<VoyageModel>> getScheduledTrips() async {
    // Simuler latence réseau
    await Future.delayed(const Duration(milliseconds: 800)); 
    
    return [
      VoyageModel(
        id: 1,
        numVoyage: "V001",
        trajetId: 101,
        busId: 201,
        dateDepart: DateTime.now().add(const Duration(hours: 2)),
        prix: 2500,
        chauffeurId: 11,
        statut: "PROGRAMMÉ",
        gareId: 1,
        nomAgence: "General Express",
        villeSource: "Douala",
        villeDestination: "Yaoundé",
      ),
      VoyageModel(
        id: 2,
        numVoyage: "V002",
        trajetId: 101,
        busId: 202,
        dateDepart: DateTime.now().add(const Duration(hours: 5)),
        prix: 3000,
        chauffeurId: 12,
        statut: "PROGRAMMÉ",
        gareId: 1,
        nomAgence: "Finexs Voyages",
        villeSource: "Douala",
        villeDestination: "Yaoundé",
      ),
      VoyageModel(
        id: 3,
        numVoyage: "V003",
        trajetId: 102,
        busId: 203,
        dateDepart: DateTime.now().add(const Duration(hours: 8)),
        prix: 3000,
        chauffeurId: 13,
        statut: "PROGRAMMÉ",
        gareId: 1,
        nomAgence: "Touristique Express",
        villeSource: "Yaoundé",
        villeDestination: "Bafoussam",
      ),
      VoyageModel(
        id: 4,
        numVoyage: "V004",
        trajetId: 103,
        busId: 204,
        dateDepart: DateTime.now().add(const Duration(hours: 1)),
        prix: 1500,
        chauffeurId: 14,
        statut: "PROGRAMMÉ",
        gareId: 1,
        nomAgence: "General Express",
        villeSource: "Douala",
        villeDestination: "Limbé",
      ),
      VoyageModel(
        id: 5,
        numVoyage: "V005",
        trajetId: 104,
        busId: 205,
        dateDepart: DateTime.now().add(const Duration(hours: 12)),
        prix: 8000,
        chauffeurId: 15,
        statut: "PROGRAMMÉ",
        gareId: 1,
        nomAgence: "Touristique Express",
        villeSource: "Yaoundé",
        villeDestination: "Garoua",
      ),
    ];
  }
}