import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:festival_mesh_app/features/chat/data/datasources/chat_local_data_source.dart';
import 'package:festival_mesh_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:festival_mesh_app/features/chat/data/models/chat_models.dart';
import 'package:festival_mesh_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:festival_mesh_app/features/chat/domain/entities/chat_entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements ChatDataSource {}
class MockLocalDataSource extends Mock implements ChatLocalDataSource {}

class FakeMessageModel extends Fake implements MessageModel {}
class FakeChatContactModel extends Fake implements ChatContactModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeMessageModel());
    registerFallbackValue(FakeChatContactModel());
  });

  late ChatRepositoryImpl repository;
  late MockRemoteDataSource mockRemote;
  late MockLocalDataSource mockLocal;

  setUp(() {
    mockRemote = MockRemoteDataSource();
    mockLocal = MockLocalDataSource();
    
    // Default setup for init
    when(() => mockLocal.getCachedContacts()).thenAnswer((_) async => []);
    when(() => mockRemote.onMessageReceived).thenAnswer((_) => const Stream.empty());

    repository = ChatRepositoryImpl(
      remoteDataSource: mockRemote,
      localDataSource: mockLocal,
    );
  });

  group('sendMessage', () {
    const tDest = 'PeerA';
    const tText = 'Hello';

    test('should call remote source and return Right', () async {
      // arrange
      when(() => mockRemote.sendMessage(any(), any())).thenAnswer((_) async => {});
      // act
      final result = await repository.sendMessage(tDest, tText);
      // assert
      expect(result, const Right(null));
      verify(() => mockRemote.sendMessage(tDest, tText)).called(1);
    });

    test('should return MeshFailure on exception', () async {
      // arrange
      when(() => mockRemote.sendMessage(any(), any())).thenThrow(Exception('Fail'));
      // act
      final result = await repository.sendMessage(tDest, tText);
      // assert
      result.fold(
        (l) => expect(l.message, contains('Fail')),
        (r) => fail('Should be Left'),
      );
    });
  });

  group('_updateChats (internal sync)', () {
    final tMsgModel = MessageModel(
      sender: 'Alice',
      receiver: 'Bob',
      text: 'Hi',
      timestamp: DateTime.now(),
      isMe: true,
    );

    test('should cache message and update internal stream', () async {
      // arrange
      final controller = StreamController<MessageModel>();
      when(() => mockRemote.onMessageReceived).thenAnswer((_) => controller.stream);
      when(() => mockLocal.cacheMessage(any())).thenAnswer((_) async => {});
      when(() => mockLocal.cacheContact(any())).thenAnswer((_) async => {});

      // Re-init repository to pick up the new stream
      repository = ChatRepositoryImpl(
        remoteDataSource: mockRemote,
        localDataSource: mockLocal,
      );

      // act & assert
      expectLater(repository.chatStream, emitsThrough(predicate((List<ChatContact> chats) {
        return chats.any((c) => c.name == 'Bob' && c.lastMessage == 'Hi');
      })));

      controller.add(tMsgModel);
    });
  });
}
