import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/chat_entities.dart';

part 'chat_models.freezed.dart';
part 'chat_models.g.dart';

@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String sender,
    required String receiver, // Added to track destination for 'isMe' messages
    required String text,
    required DateTime timestamp,
    required bool isMe,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  factory MessageModel.fromFfi(String sender, String receiver, String text, bool isMe) => MessageModel(
        sender: sender,
        receiver: receiver,
        text: text,
        timestamp: DateTime.now(),
        isMe: isMe,
      );

  factory MessageModel.fromEntity(Message entity, String receiver) => MessageModel(
        sender: entity.sender,
        receiver: receiver,
        text: entity.text,
        timestamp: entity.timestamp,
        isMe: entity.isMe,
      );
}

extension MessageModelMapper on MessageModel {
  Message toEntity() => Message(
        sender: sender,
        text: text,
        timestamp: timestamp,
        isMe: isMe,
      );
}

@freezed
class ChatContactModel with _$ChatContactModel {
  const factory ChatContactModel({
    required String name,
    required String lastMessage,
    required List<MessageModel> messages,
  }) = _ChatContactModel;

  factory ChatContactModel.fromJson(Map<String, dynamic> json) =>
      _$ChatContactModelFromJson(json);
}

extension ChatContactModelMapper on ChatContactModel {
  ChatContact toEntity() => ChatContact(
        name: name,
        lastMessage: lastMessage,
        messages: messages.map((m) => m.toEntity()).toList(),
      );
}
