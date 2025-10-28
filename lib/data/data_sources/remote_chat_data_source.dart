import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/chat_entity.dart';

class RemoteChatDataSource {
  final CollectionReference messagesRef =
  FirebaseFirestore.instance.collection('messages');

  Stream<List<ChatEntity>> getMessages() {
    return messagesRef.orderBy('timestamp').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ChatEntity(
          id: doc.id,
          text: data['text'] ?? '',
          senderId: data['senderId'] ?? '',
          senderEmail: data['senderEmail'] ?? 'Unknown',
          isSent: true,
          timestamp: (data['timestamp'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }


Future<void> sendMessage(ChatEntity message) async {
  await messagesRef.doc(message.id).set({
    'text': message.text,
    'senderId': message.senderId,
    'senderEmail': message.senderEmail,
    'timestamp': message.timestamp,
  });
}
  Future<void> deleteMessage(String id) async {
    await messagesRef.doc(id).delete();
  }
  Future<void> editMessage(String id, String newText) async {
    await messagesRef.doc(id).update({'text': newText});
  }

}
