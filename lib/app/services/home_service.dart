import 'package:camer_trip/app/models/ag_model.dart';
import 'package:camer_trip/app/models/destination_model.dart';
import 'package:camer_trip/app/models/promo_trip_model.dart';
import 'package:dio/dio.dart';
import 'api_client_service.dart';

class HomeService {
  final Dio dio = ApiClient().dio;

  Future<List<Agence>> getAgencesPartenaires() async {
    final response = await dio.get('/agences');
    final data = response.data["data"];
    if (data == null) return [];
    final List<dynamic> list = data;
    return list.map((json) => Agence.fromJson(json)).toList();
  }

  Future<List<Destination>> getDestinationsPopulaires() async {
    try {
      final response = await dio.get('/trajets-populaires');
      final List<dynamic> list = response.data["data"];
      return list.map((json) => Destination.fromJson(json)).toList();
    } catch (e) {
      print("Erreur getDestinationsPopulaires : \$e");
      return [];
    }
  }

  Future<List<PromoTrip>> getPromoTrips() async {
    try {
      final response = await dio.get('/promo-trips');
      final List<dynamic> list = response.data["data"];
      return list.map((json) => PromoTrip.fromJson(json)).toList();
    } catch (e) {
      print("Erreur getPromoTrips : \$e");
      return [];
    }
  }

}
