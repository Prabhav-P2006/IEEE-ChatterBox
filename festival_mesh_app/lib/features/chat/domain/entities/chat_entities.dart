import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_entities.freezed.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required String sender,
    required String text,
    required DateTime timestamp,
    required bool isMe,
  }) = _Message;
}

@freezed
class ChatContact with _$ChatContact {
  const factory ChatContact({
    required String name,
    required String lastMessage,
    String? safetyNumber,
    @Default([]) List<Message> messages,
  }) = _ChatContact;
}
