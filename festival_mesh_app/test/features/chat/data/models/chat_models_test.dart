import 'package:flutter_test/flutter_test.dart';
import 'package:festival_mesh_app/features/chat/data/models/chat_models.dart';
import 'package:festival_mesh_app/features/chat/domain/entities/chat_entities.dart';

void main() {
  final tDateTime = DateTime(2023, 1, 1);
  final tMessageModel = MessageModel(
    sender: 'Alice',
    receiver: 'Bob',
    text: 'Hello',
    timestamp: tDateTime,
    isMe: true,
  );

  final tMessage = Message(
    sender: 'Alice',
    text: 'Hello',
    timestamp: tDateTime,
    isMe: true,
  );

  group('MessageModel', () {
    test('should be a subclass of Message entity through mapping', () {
      // act
      final result = tMessageModel.toEntity();
      // assert
      expect(result, tMessage);
    });

    test('fromEntity should return a valid model', () {
      // act
      final result = MessageModel.fromEntity(tMessage, 'Bob');
      // assert
      expect(result, tMessageModel);
    });

    test('fromJson/toJson should work correctly', () {
      // arrange
      final json = {
        'sender': 'Alice',
        'receiver': 'Bob',
        'text': 'Hello',
        'timestamp': tDateTime.toIso8601String(),
        'isMe': true,
      };
      // act
      final result = MessageModel.fromJson(json);
      // assert
      expect(result, tMessageModel);
      expect(tMessageModel.toJson(), json);
    });
  });

  group('ChatContactModel', () {
    final tContactModel = ChatContactModel(
      name: 'Bob',
      lastMessage: 'Hello',
      messages: [tMessageModel],
    );

    final tContact = ChatContact(
      name: 'Bob',
      lastMessage: 'Hello',
      messages: [tMessage],
    );

    test('toEntity should return a valid entity', () {
      // act
      final result = tContactModel.toEntity();
      // assert
      expect(result, tContact);
    });
  });
}
