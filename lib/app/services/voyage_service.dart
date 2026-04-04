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
}