import 'package:dio/dio.dart';
import 'api_client_service.dart';

class ChatService {
  final Dio dio = ApiClient().dio;

  Future<String> sendMessage(String message, List<Map<String, String>> history) async {
    try {
      final response = await dio.post(
        "/chat",
        data: {
          "message": message,
          "history": history,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['answer'] ?? "Désolé, je n'ai pas pu générer une réponse.";
      }
      
      throw Exception("Erreur inattendue du serveur.");
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw Exception("Votre session a expiré. Veuillez vous reconnecter pour continuer la conversation.");
      }
      if (e.response?.statusCode == 422) {
        throw Exception("Données invalides envoyées au serveur.");
      }
      throw Exception("Erreur de connexion. Veuillez vérifier votre accès à internet.");
    } catch (e) {
      throw Exception("Une erreur s'est produite. Veuillez réessayer.");
    }
  }
  Future<List<Map<String, dynamic>>> getChatHistory() async {
    try {
      final response = await dio.get("/chat/history");
      if (response.statusCode == 200 && response.data['status'] == true) {
        return List<Map<String, dynamic>>.from(response.data['data']);
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}
