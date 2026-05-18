import 'package:dio/dio.dart';
import '../models/notification_model.dart';
import 'api_client_service.dart';

class NotificationService {
  final Dio dio = ApiClient().dio;

  // Récupérer toutes les notifications
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await dio.get('/notifications');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => NotificationModel.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print("Erreur getNotifications: $e");
      return [];
    }
  }

  // Marquer une notification comme lue
  Future<bool> markAsRead(int id) async {
    try {
      final response = await dio.patch('/notifications/$id/read');
      return response.statusCode == 200;
    } catch (e) {
      print("Erreur markAsRead: $e");
      return false;
    }
  }

  // Tout marquer comme lu
  Future<bool> markAllAsRead() async {
    try {
      final response = await dio.post('/notifications/read-all');
      return response.statusCode == 200;
    } catch (e) {
      print("Erreur markAllAsRead: $e");
      return false;
    }
  }

  // Supprimer une notification
  Future<bool> deleteNotification(int id) async {
    try {
      final response = await dio.delete('/notifications/$id');
      return response.statusCode == 200;
    } catch (e) {
      print("Erreur deleteNotification: $e");
      return false;
    }
  }
}
