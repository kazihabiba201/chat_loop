import 'package:hive/hive.dart';
import '../../domain/entities/chat_entity.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 0)
class ChatModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String text;
  @HiveField(2)
  final String senderId;
  @HiveField(3)
  bool isSent;
  @HiveField(4)
  final DateTime timestamp;
  @HiveField(5)
  final String? senderEmail;

  ChatModel({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderEmail,
    this.isSent = false,
    required this.timestamp,
  });


  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      text: entity.text,
      senderId: entity.senderId,
      senderEmail: entity.senderEmail,
      isSent: entity.isSent,
      timestamp: entity.timestamp,
    );
  }


  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      text: text,
      senderId: senderId,
      senderEmail: senderEmail ?? 'Unknown',
      isSent: isSent,
      timestamp: timestamp,
    );
  }
}
