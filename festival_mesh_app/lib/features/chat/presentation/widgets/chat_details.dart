import 'package:flutter/material.dart';
import '../../domain/entities/chat_entities.dart';

class ChatDetails extends StatelessWidget {
  final ChatContact chatContact;
  final VoidCallback onTap;

  const ChatDetails({
    Key? key,
    required this.chatContact,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.blue.shade100,
        child: Text(chatContact.name[0].toUpperCase(), 
          style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
      ),
      title: Text(
        chatContact.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(
        chatContact.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.grey.shade600),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text("Just now", style: TextStyle(color: Colors.grey, fontSize: 12)),
          SizedBox(height: 5),
          // Unread indicator placeholder
        ],
      ),
    );
  }
}
