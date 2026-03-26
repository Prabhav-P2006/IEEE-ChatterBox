// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      sender: json['sender'] as String,
      receiver: json['receiver'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isMe: json['isMe'] as bool,
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'sender': instance.sender,
      'receiver': instance.receiver,
      'text': instance.text,
      'timestamp': instance.timestamp.toIso8601String(),
      'isMe': instance.isMe,
    };

_$ChatContactModelImpl _$$ChatContactModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatContactModelImpl(
      name: json['name'] as String,
      lastMessage: json['lastMessage'] as String,
      messages: (json['messages'] as List<dynamic>)
          .map((e) => MessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ChatContactModelImplToJson(
        _$ChatContactModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'lastMessage': instance.lastMessage,
      'messages': instance.messages,
    };
