import 'package:dio/dio.dart';
import '../models/colis_model.dart';
import 'api_client_service.dart';

class ColisService {
  final Dio dio = ApiClient().dio;

  Future<List<ColisModel>> getMyColis() async {
    try {
      final response = await dio.get('/client/colis');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ColisModel.fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      print("Erreur getMyColis: ${e.response?.data}");
      return [];
    }
  }
}
