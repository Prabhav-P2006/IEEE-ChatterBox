import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/messages.dart';
import '../widgets/new_message.dart';

@RoutePage()
class MessageScreen extends StatelessWidget {
  final String peerName;

  const MessageScreen({Key? key, required this.peerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return switch (state) {
          ChatLoaded(:final chats) => () {
              final contact = chats.where((c) => c.name == peerName).firstOrNull;
              
              if (contact == null) {
                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.blue.shade800,
                    title: Text(peerName, style: const TextStyle(color: Colors.white)),
                  ),
                  body: const Center(child: Text("Contact no longer available")),
                );
              }

              return Scaffold(
                backgroundColor: Colors.blue.shade800,
                appBar: AppBar(
                  backgroundColor: Colors.blue.shade800,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    onPressed: () => context.router.pop(),
                  ),
                  title: Text(contact.name, style: const TextStyle(color: Colors.white)),
                  centerTitle: true,
                ),
                body: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(child: Messages(chatContact: contact)),
                      NewMessage(chatContact: contact),
                    ],
                  ),
                ),
              );
            }(),
          _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
        };
      },
    );
  }
}
