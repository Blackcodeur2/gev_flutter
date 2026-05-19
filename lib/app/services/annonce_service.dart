import 'package:dio/dio.dart';
import '../models/annonce_model.dart';
import 'api_client_service.dart';

class AnnonceService {
  final Dio dio = ApiClient().dio;

  Future<List<AnnonceModel>> getAnnonces() async {
    try {
      final response = await dio.get('/annonces');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => AnnonceModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print("Erreur getAnnonces: ${e.response?.data}");
      return [];
    }
  }
}
