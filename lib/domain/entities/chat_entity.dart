class ChatEntity {
  final String id;
  String text;
  final String senderId;
  final String senderEmail;
  bool isSent;
  final DateTime timestamp;

  ChatEntity({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderEmail,
    this.isSent = false,
    required this.timestamp,
  });


  ChatEntity copyWith({
    String? id,
    String? text,
    String? senderId,
    String? senderEmail,
    bool? isSent,
    DateTime? timestamp,
  }) {
    return ChatEntity(
      id: id ?? this.id,
      text: text ?? this.text,
      senderId: senderId ?? this.senderId,
      senderEmail: senderEmail ?? this.senderEmail,
      isSent: isSent ?? this.isSent,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
