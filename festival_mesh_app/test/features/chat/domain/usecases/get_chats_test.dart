import 'package:dartz/dartz.dart';
import 'package:festival_mesh_app/features/chat/domain/entities/chat_entities.dart';
import 'package:festival_mesh_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:festival_mesh_app/features/chat/domain/usecases/get_chats.dart';
import 'package:festival_mesh_app/core/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late GetChats usecase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    usecase = GetChats(mockRepository);
  });

  test('should get chats stream from the repository', () async {
    // arrange
    final stream = Stream.value(<ChatContact>[]);
    when(() => mockRepository.chatStream).thenAnswer((_) => stream);
    
    // act
    final result = await usecase(NoParams());
    
    // assert
    expect(result, Right(stream));
    verify(() => mockRepository.chatStream).called(1);
  });
}
