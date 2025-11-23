class ChatMessageModel {
  final String text;
  final bool isUser; // true = user, false = AI
  final DateTime timestamp;

  ChatMessageModel({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}