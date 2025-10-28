import '../../domain/entities/chat_entity.dart';
import '../data_sources/local_chat_data_source.dart';
import '../data_sources/remote_chat_data_source.dart';
import '../models/chat_model.dart';

abstract class ChatRepository {
  Stream<List<ChatEntity>> getMessages();
  Future<void> sendMessage(ChatEntity message);
  Future<void> editMessage(String id, String newText);


  Future<void> deleteMessage(String id);

}

class ChatRepositoryImpl implements ChatRepository {
  final LocalChatDataSource local;
  final RemoteChatDataSource remote;

  ChatRepositoryImpl({required this.local, required this.remote});
  Future<void> deleteMessage(String id) async {
    await local.deleteMessage(id);
    await remote.deleteMessage(id);
  }

  Future<void> editMessage(String id, String newText) async {
    await local.updateMessageText(id, newText);
    await remote.editMessage(id, newText);
  }
  @override
  Stream<List<ChatEntity>> getMessages() {
    return remote.getMessages();
  }


  @override
  Future<void> sendMessage(ChatEntity message) async {
    final model = ChatModel.fromEntity(message);
    await local.saveMessage(model);
    try {
      await remote.sendMessage(message);
      message.isSent = true;
      await local.updateMessageStatus(model);
    } catch (_) {

    }
  }
}
