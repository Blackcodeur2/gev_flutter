import 'dart:io';
import 'package:dio/dio.dart';
import 'api_client_service.dart';

class KwcService {
  final Dio dio = ApiClient().dio;

  Future<void> uploadCni(File file) async {
    try {
      FormData formData = FormData.fromMap({
        "type": "cni",
        "fichier": await MultipartFile.fromFile(file.path),
      });

      await dio.post("/upload-cni", data: formData);
    } catch (e) {
      print("Erreur upload: $e");
    }
  }
}