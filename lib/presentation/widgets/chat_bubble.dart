import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants.dart';
import '../../domain/entities/chat_entity.dart';

class ChatBubble extends StatelessWidget {
  final ChatEntity message;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const ChatBubble({
    super.key,
    required this.message,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    bool isMe = message.senderId == currentUserId;

    return GestureDetector(
      onLongPress: isMe ? onEdit : null,
      child: Dismissible(
        key: Key(message.id),
        direction: isMe ? DismissDirection.endToStart : DismissDirection.none,
        background: Container(
          color: Colors.pinkAccent.shade200,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: isMe
            ? (direction) {
          if (onDelete != null) onDelete!();
        }
            : null,
        child: Align(
          alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? Colors.pinkAccent.shade100 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isMe)
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: getColorForEmail(message.senderEmail),
                    child: Text(
                      message.senderEmail.isNotEmpty
                          ? message.senderEmail[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                if (!isMe) const SizedBox(width: 6),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isMe)
                        Text(
                          message.senderEmail.split('@').first,
                          style: const TextStyle(fontSize: 10, color: Colors.black54),
                        ),

                      Text(
                        message.text,
                        style: TextStyle(color: isMe ? Colors.white : Colors.black),
                      ),
                      if (isMe)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Icon(
                            message.isSent ? Icons.done_all : Icons.access_time,
                            size: 14,
                            color: Colors.white70,
                          ),
                        ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
