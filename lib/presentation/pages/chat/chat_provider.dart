import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/data_sources/local_chat_data_source.dart';
import '../../../data/data_sources/remote_chat_data_source.dart';
import '../../../data/models/chat_model.dart';
import '../../../data/repositories/chat_repository_impl.dart';
import '../../../domain/entities/chat_entity.dart';

final localChatDataSourceProvider = Provider((ref) => LocalChatDataSource());
final remoteChatDataSourceProvider = Provider((ref) => RemoteChatDataSource());
final chatRepositoryProvider = Provider<ChatRepositoryImpl>((ref) {
  final local = ref.watch(localChatDataSourceProvider);
  final remote = ref.watch(remoteChatDataSourceProvider);
  return ChatRepositoryImpl(local: local, remote: remote);
});
final chatProvider = StateNotifierProvider<ChatProvider, List<ChatEntity>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return ChatProvider(repository);
});

class ChatProvider extends StateNotifier<List<ChatEntity>> {
  final ChatRepositoryImpl repository;

  ChatProvider(this.repository) : super([]) {
    _init();
  }

  void _init() async {

    final localMessages = repository.local.getAllMessages();
    state = localMessages.map((m) => m.toEntity()).toList();


    repository.getMessages().listen((remoteMessages) {
      final pending = state.where((m) => !m.isSent).toList();


      final pendingIds = pending.map((m) => m.id).toSet();


      final uniqueRemote = remoteMessages.where((m) => !pendingIds.contains(m.id)).toList();


      state = [...uniqueRemote, ...pending];
    });




    Connectivity().onConnectivityChanged.listen((connectivityResult) async {
      if (connectivityResult != ConnectivityResult.none) {
        await _sendPendingMessages();
      }
    });


    await _sendPendingMessages();
  }

  Future<void> _sendPendingMessages() async {
    final pending = state.where((m) => !m.isSent).toList();
    for (var msg in pending) {
      try {
        await repository.sendMessage(msg);
        msg.isSent = true;
        state = state.map((m) => m.id == msg.id ? msg : m).toList();



        await repository.local.updateMessageStatus(ChatModel.fromEntity(msg));
      } catch (_) {

      }
    }
    state = [...state];
  }

  Future<void> sendMessage(String text, String senderId, String senderEmail) async {
    final msg = ChatEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      senderId: senderId,
      senderEmail: senderEmail,
      isSent: false,
      timestamp: DateTime.now(),
    );


    state = [...state, msg];
    await repository.local.saveMessage(ChatModel.fromEntity(msg));


    var connectivity = await Connectivity().checkConnectivity();
    if (connectivity != ConnectivityResult.none) {
      try {
        await repository.sendMessage(msg);
        msg.isSent = true;
        state = [...state];
        await repository.local.updateMessageStatus(ChatModel.fromEntity(msg));
      } catch (_) {

      }
    }
  }

  Future<void> deleteMessage(String id) async {
    state = state.where((msg) => msg.id != id).toList();
    await repository.deleteMessage(id);
  }

  Future<void> editMessage(String id, String newText) async {
    for (var msg in state) {
      if (msg.id == id) {
        msg.text = newText;
        break;
      }
    }
    state = [...state];
    await repository.editMessage(id, newText);
  }
}
