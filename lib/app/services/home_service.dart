import 'package:camer_trip/app/models/ag_model.dart';
import 'package:camer_trip/app/models/destination_model.dart';
import 'package:camer_trip/app/models/promo_trip_model.dart';
import 'package:dio/dio.dart';
import 'api_client_service.dart';

class HomeService {
  final Dio dio = ApiClient().dio;

  Future<List<Agence>> getAgencesPartenaires() async {
    try {
      final response = await dio.get('/client/agences');
      final List<dynamic> list = response.data["data"];
      return list.map((json) => Agence.fromJson(json)).toList();
    } catch (e) {
      print("Erreur getAgencesPartenaires : \$e");
      return [];
    }
  }

  Future<List<Destination>> getDestinationsPopulaires() async {
    try {
      final response = await dio.get('/client/trajets-populaires');
      final List<dynamic> list = response.data["data"];
      return list.map((json) => Destination.fromJson(json)).toList();
    } catch (e) {
      print("Erreur getDestinationsPopulaires : \$e");
      return [];
    }
  }

  Future<List<PromoTrip>> getPromoTrips() async {
    try {
      final response = await dio.get('/client/promo-trips');
      final List<dynamic> list = response.data["data"];
      return list.map((json) => PromoTrip.fromJson(json)).toList();
    } catch (e) {
      print("Erreur getPromoTrips : \$e");
      return [];
    }
  }
}
