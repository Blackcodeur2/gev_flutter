class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final bool isError;

  ChatMessage({
    required this.text, 
    required this.isUser, 
    required this.time,
    this.isError = false,
  });

  Map<String, String> toHistory() {
    return {
      "role": isUser ? "user" : "assistant",
      "content": text,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'time': time.toIso8601String(),
      'isError': isError,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] ?? '',
      isUser: json['isUser'] ?? false,
      time: json['time'] != null ? DateTime.parse(json['time']) : DateTime.now(),
      isError: json['isError'] ?? false,
    );
  }
}
