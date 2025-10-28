import 'package:chat_app/core/service/auth_service.dart';
import 'package:chat_app/presentation/pages/chat/chat_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import '../../../core/app_image.dart';
import '../../../core/constants.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../core/routes/routes.dart';
import '../../../data/models/chat_model.dart';
import '../../widgets/chat_bubble.dart';
import '../../widgets/input_field.dart';
import '../language_switch.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _bubbleKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      showSpeechBubble(context);
    });
  }


  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: const Color(0xffE68CA9),
          title:  Text(
            AppLocalizations.of(context)!.chat,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            Row(
              children: [
                const LanguageSwitcher(),
                Text(
                  AppLocalizations.of(context)!.language,
                  style: const TextStyle(color: Colors.white),
                ),

              ],
            ),
            InkWell(
              onTap: () async {
                await ref.read(localeProvider.notifier).resetToEnglish();
                AuthService().signOut();
                await Hive.box<ChatModel>(HiveBoxes.messages).clear();
                context.go(RoutePaths.login);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Image.asset(
                  color: Colors.white,
                  AppImages.logOutLogo,
                  // height: 25,
                  // width: 25,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ]),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
                bool isMe = msg.senderId == currentUserId;

                return ChatBubble(
                  message: msg,
                  onDelete: isMe
                      ? () async {
                          await ref.read(chatProvider.notifier).deleteMessage(msg.id);
                        }
                      : null,
                  onEdit: isMe
                      ? () async {
                          final controller = TextEditingController(text: msg.text);
                          final newText = await showDialog<String>(
                            context: context,
                            builder: (_) => AlertDialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title:  Center(child: Column(
                                children: [
                                  Text("Update your message?", style: TextStyle(fontSize: 17, color: Colors.pinkAccent.shade200,fontWeight: FontWeight.w700),),

                                ],
                              )),
                              actionsAlignment: MainAxisAlignment.center,
                              content: TextField(controller: controller),
                              actions: [
                                ElevatedButton(style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.pinkAccent.shade200,
                                  side: BorderSide(color: Colors.pinkAccent.shade200),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ), onPressed: (){Navigator.pop(context);},child: const Text("Cancel")),
                                ElevatedButton(style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pinkAccent.shade200,
                                  foregroundColor: Colors.white,
                                  side: BorderSide(color: Colors.pinkAccent.shade200),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),onPressed: ()=> Navigator.pop(context, controller.text), child: const Text("Save")),
                              ],
                            ),
                          );

                          if (newText != null && newText.trim().isNotEmpty) {
                            await ref.read(chatProvider.notifier).editMessage(msg.id, newText.trim());
                          }
                        }
                      : null,
                );
              },
            ),
          ),
          InputField(),
        ],
      ),
    );
  }
}
void showSpeechBubble(BuildContext context,) async {
  await Future.delayed(const Duration(milliseconds: 1000));



  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) {
      return Stack(
        children: [
          Positioned(
            right: 20,
            top: 80,
            child: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6,
                ),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child:  Text(
                    AppLocalizations.of(context)!.speechBubble,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(milliseconds: 3000), () {
    overlayEntry.remove();
  });
}