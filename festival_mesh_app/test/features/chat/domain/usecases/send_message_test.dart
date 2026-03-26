import 'package:dartz/dartz.dart';
import 'package:festival_mesh_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:festival_mesh_app/features/chat/domain/usecases/send_message.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late SendMessage usecase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    usecase = SendMessage(mockRepository);
  });

  const tDest = "PeerA";
  const tText = "Hello";
  const tParams = SendMessageParams(dest: tDest, text: tText);

  test('should send message to the repository', () async {
    // arrange
    when(() => mockRepository.sendMessage(any(), any()))
        .thenAnswer((_) async => const Right(null));

    // act
    final result = await usecase(tParams);

    // assert
    expect(result, const Right(null));
    verify(() => mockRepository.sendMessage(tDest, tText)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
