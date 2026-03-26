import 'package:hive_ce/hive.dart';
import '../models/chat_models.dart';

abstract class ChatLocalDataSource {
  Future<void> cacheMessage(MessageModel message);
  Future<List<MessageModel>> getMessageHistory(String peer);
  Future<void> cacheContact(ChatContactModel contact);
  Future<List<ChatContactModel>> getCachedContacts();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  static const String _msgBox = 'messages';
  static const String _contactBox = 'contacts';

  @override
  Future<void> cacheMessage(MessageModel message) async {
    final box = await Hive.openBox<Map>(_msgBox);
    final key = "${message.sender}_${message.receiver}_${message.timestamp.millisecondsSinceEpoch}";
    await box.put(key, message.toJson());
  }

  @override
  Future<List<MessageModel>> getMessageHistory(String peer) async {
    final box = await Hive.openBox<Map>(_msgBox);
    return box.values
        .map((e) => MessageModel.fromJson(Map<String, dynamic>.from(e)))
        .where((m) => m.sender == peer || m.receiver == peer) // Robust filtering using 'peer'
        .toList();
  }

  @override
  Future<void> cacheContact(ChatContactModel contact) async {
    final box = await Hive.openBox<Map>(_contactBox);
    await box.put(contact.name, contact.toJson());
  }

  @override
  Future<List<ChatContactModel>> getCachedContacts() async {
    final box = await Hive.openBox<Map>(_contactBox);
    return box.values
        .map((e) => ChatContactModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
