import 'package:hive/hive.dart';
import '../../core/constants.dart';
import '../models/chat_model.dart';

class LocalChatDataSource {
  final Box<ChatModel> box = Hive.box<ChatModel>(HiveBoxes.messages);


  Future<void> saveMessage(ChatModel message) async {
    await box.put(message.id, message);
  }


  Future<void> updateMessageStatus(ChatModel message) async {
    await message.save();
  }


  Future<void> updateMessageText(String id, String newText) async {
    final message = box.get(id);
    if (message != null) {
      message.text = newText;
      await message.save();
    }
  }


  Future<void> deleteMessage(String id) async {
    await box.delete(id);
  }


  List<ChatModel> getAllMessages() {
    return box.values.toList();
  }


  Stream<List<ChatModel>> watchMessages() async* {
    yield box.values.toList();
    box.watch().listen((event) {
      final updated = box.values.toList();
    });
  }
}
