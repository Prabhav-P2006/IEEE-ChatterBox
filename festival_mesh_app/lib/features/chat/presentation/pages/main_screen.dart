import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../bloc/chat_bloc.dart';
import '../widgets/chat_details.dart';
import 'package:festival_mesh_app/core/router/app_router.dart';

@RoutePage()
class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return switch (state) {
            ChatInitial() || ChatLoading() => const Center(child: CircularProgressIndicator()),
            ChatLoaded(:final chats, :final myId, :final error) => Column(
                children: <Widget>[
                  Container(
                    height: 120.0,
                    padding: const EdgeInsets.only(top: 60.0, left: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Chats',
                          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: IconButton(
                            icon: const Icon(Icons.settings, color: Colors.white),
                            onPressed: () => context.router.push(const SettingRoute()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                        child: chats.isEmpty
                            ? Center(child: Text("No mesh peers found", style: TextStyle(color: Colors.grey.shade400)))
                            : ListView.builder(
                                itemCount: chats.length,
                                itemBuilder: (context, index) {
                                  final chat = chats[index];
                                  return ChatDetails(
                                    chatContact: chat,
                                    onTap: () => context.router.push(MessageRoute(peerName: chat.name)),
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ],
              ),
          };
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade800,
        onPressed: () {
          context.read<ChatBloc>().add(ChatEvent.handshakeSent("Peer_${DateTime.now().minute}"));
        },
        child: const Icon(Icons.bluetooth_searching, color: Colors.white),
      ),
    );
  }
}
