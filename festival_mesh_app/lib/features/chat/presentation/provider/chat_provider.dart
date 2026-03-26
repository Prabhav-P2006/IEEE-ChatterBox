import 'package:flutter/material.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepository repository;
  final String myName;

  List<ChatContact> _chats = [];
  List<ChatContact> get chats => _chats;

  String _myId = "";
  String get myId => _myId;

  ChatProvider({required this.repository, required this.myName}) {
    _init();
  }

  void _init() async {
    _myId = await repository.getMyIdentity();
    repository.chatStream.listen((updatedChats) {
      _chats = updatedChats;
      notifyListeners();
    });
    notifyListeners();
  }

  Future<void> sendMessage(String dest, String text) async {
    await repository.sendMessage(dest, text);
  }

  Future<void> sendHandshake(String dest) async {
    await repository.sendHandshake(dest);
  }

  String getSafetyNumber(String peer) {
    // In a real use case, this would be an async call in the UI or cached
    return "N/A"; // Placeholder for sync demo
  }
}
