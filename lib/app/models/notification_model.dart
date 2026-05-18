class NotificationModel {
  final int id;
  final int userId;
  final int? senderId;
  final String title;
  final String message;
  final String type;
  final Map<String, dynamic>? data;
  final DateTime? readAt;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    this.senderId,
    required this.title,
    required this.message,
    required this.type,
    this.data,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      userId: json['user_id'],
      senderId: json['sender_id'],
      title: json['title'] ?? 'Notification',
      message: json['message'] ?? '',
      type: json['type'] ?? 'GENERAL',
      data: json['data'] is Map ? Map<String, dynamic>.from(json['data']) : null,
      readAt: json['read_at'] != null ? DateTime.parse(json['read_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
