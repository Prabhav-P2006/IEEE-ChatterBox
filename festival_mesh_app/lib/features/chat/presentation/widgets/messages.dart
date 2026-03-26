import 'package:flutter/material.dart';
import '../../domain/entities/chat_entities.dart';
import 'chat_bubble.dart';

class Messages extends StatelessWidget {
  final ChatContact chatContact;

  const Messages({Key? key, required this.chatContact}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      reverse: false,
      padding: const EdgeInsets.all(20),
      itemCount: chatContact.messages.length,
      itemBuilder: (context, index) {
        final msg = chatContact.messages[index];
        return ChatBubble(message: msg);
      },
    );
  }
}
