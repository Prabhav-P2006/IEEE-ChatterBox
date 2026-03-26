import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:festival_mesh_app/core/error/failures.dart';
import 'package:festival_mesh_app/features/chat/domain/entities/chat_entities.dart';
import 'package:festival_mesh_app/features/chat/domain/usecases/get_chats.dart';
import 'package:festival_mesh_app/features/chat/domain/usecases/get_identity.dart';
import 'package:festival_mesh_app/features/chat/domain/usecases/send_handshake.dart';
import 'package:festival_mesh_app/features/chat/domain/usecases/send_message.dart';
import 'package:festival_mesh_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:festival_mesh_app/core/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSendMessage extends Mock implements SendMessage {}
class MockSendHandshake extends Mock implements SendHandshake {}
class MockGetChats extends Mock implements GetChats {}
class MockGetIdentity extends Mock implements GetIdentity {}

void main() {
  late ChatBloc bloc;
  late MockSendMessage mockSendMessage;
  late MockSendHandshake mockSendHandshake;
  late MockGetChats mockGetChats;
  late MockGetIdentity mockGetIdentity;

  setUpAll(() {
    // Removed const for stability in test isolate compiler
    registerFallbackValue(SendMessageParams(dest: '', text: ''));
    registerFallbackValue(const NoParams());
  });

  setUp(() {
    mockSendMessage = MockSendMessage();
    mockSendHandshake = MockSendHandshake();
    mockGetChats = MockGetChats();
    mockGetIdentity = MockGetIdentity();

    bloc = ChatBloc(
      sendMessage: mockSendMessage,
      sendHandshake: mockSendHandshake,
      getChats: mockGetChats,
      getIdentity: mockGetIdentity,
    );
  });

  test('initial state is ChatInitial', () {
    expect(bloc.state, const ChatInitial());
  });

  group('ChatStarted', () {
    const tId = '0xABC';
    
    blocTest<ChatBloc, ChatState>(
      'emits Loading then Loaded',
      build: () {
        when(() => mockGetIdentity(any())).thenAnswer((_) async => const Right(tId));
        when(() => mockGetChats(any())).thenAnswer((_) async => Right(Stream.value([])));
        return bloc;
      },
      act: (b) => b.add(const ChatStarted()),
      expect: () => [
        const ChatLoading(),
        const ChatLoaded(chats: [], myId: tId),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'emits Error on failure',
      build: () {
        when(() => mockGetIdentity(any())).thenAnswer((_) async => const Right(tId));
        when(() => mockGetChats(any())).thenAnswer((_) async => const Left(MeshFailure('Fail')));
        return bloc;
      },
      act: (b) => b.add(const ChatStarted()),
      expect: () => [
        const ChatLoading(),
        const ChatLoaded(chats: [], myId: tId, error: 'Fail'),
      ],
    );
  });
}
