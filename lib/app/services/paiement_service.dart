import 'package:dio/dio.dart';
import '../utils/api_error_handler.dart';
import 'api_client_service.dart';

class PaiementService {
  final Dio dio = ApiClient().dio;

  // Initie un paiement CamPay via le backend
  Future<Map<String, dynamic>?> initiatePayment({
    required int reservationId,
    required String phone,
  }) async {
    try {
      final response = await dio.post(
        '/payments/initiate',
        data: {
          'reservation_id': reservationId,
          'phone': phone,
        },
      );
      
      if (response.statusCode == 200) {
        return response.data;
      }
      return null;
    } on DioException catch (e) {
      print("Erreur initiation paiement: ${e.response?.data}");
      rethrow;
    }
  }

  // Vérifie le statut d'un paiement
  Future<Map<String, dynamic>> checkPaymentStatus(String reference) async {
    try {
      final response = await dio.get('/payments/status/$reference');
      if (response.statusCode == 200) {
        return {
          'statut': response.data['statut'] ?? 'PENDING',
          'reason': response.data['reason'],
        };
      }
      return {'statut': 'FAILED', 'reason': 'Erreur serveur'};
    } catch (e) {
      print("Erreur check status: $e");
      return {
        'statut': 'ERROR',
        'reason': ApiErrorHandler.userMessage(
          e,
          fallback: 'Impossible de vérifier le paiement',
        ),
      };
    }
  }
}
