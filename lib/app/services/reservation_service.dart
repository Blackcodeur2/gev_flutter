import 'package:dio/dio.dart';
import 'api_client_service.dart';

class ReservationService {
  final Dio dio = ApiClient().dio;

  // Créer une nouvelle réservation (Aligné sur le modèle Laravel)
  Future<Response?> createReservation({
    required int voyageId,
    required int gareId,
    required String place,
    required double prix,
    required String telephonePaiement,
    required String methodePaiement,
  }) async {
    try {
      final response = await dio.post(
        '/client/reservations',
        data: {
          'voyage_id': voyageId,
          'gare_id': gareId,
          'place': place,
          'prix': prix,
          'payment_phone': telephonePaiement, // Champ utile pour l'API
          'payment_method': methodePaiement,   // Champ utile pour l'API
        },
      );
      return response;
    } on DioException catch (e) {
      print("Erreur création réservation: ${e.response?.data}");
      rethrow;
    }
  }

  // Récupérer les places occupées pour un voyage
  Future<List<String>> getOccupiedSeats(int voyageId) async {
    try {
      final response = await dio.get('/client/voyages/$voyageId/occupations');
      if (response.statusCode == 200) {
        // Supposons que l'API renvoie { "occupied": ["1", "5"] }
        return List<String>.from(response.data['occupied']);
      }
      return [];
    } catch (e) {
      print("Erreur places occupées: $e");
      // Simulation pour le moment
      return ["1", "5", "12", "18"];
    }
  }
}
