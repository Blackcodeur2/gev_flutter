import 'package:camer_trip/app/models/voyage_model.dart';
import 'package:dio/dio.dart';
import 'api_client_service.dart';

class VoyageService {
  final Dio dio = ApiClient().dio;

  Future<List<VoyageModel>> getScheduledTrips() async {
    try {
      final response = await dio.post('/client/search-trips');
      final List<dynamic> data = response.data["data"];
      
      return data.map((json) => VoyageModel.fromJson(json)).toList();
    } catch (e) {
      print("Erreur getScheduledTrips : $e");
      return [];
    }
  }

}
