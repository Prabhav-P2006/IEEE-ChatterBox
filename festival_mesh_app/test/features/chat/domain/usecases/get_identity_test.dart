import 'package:dartz/dartz.dart';
import 'package:festival_mesh_app/core/error/failures.dart';
import 'package:festival_mesh_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:festival_mesh_app/features/chat/domain/usecases/get_identity.dart';
import 'package:festival_mesh_app/core/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockChatRepository extends Mock implements ChatRepository {}

void main() {
  late GetIdentity usecase;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    usecase = GetIdentity(mockRepository);
  });

  test('should get identity from the repository', () async {
    // arrange
    const tId = '0x1234';
    when(() => mockRepository.getMyIdentity()).thenAnswer((_) async => tId);
    
    // act
    final result = await usecase(NoParams());
    
    // assert
    expect(result, const Right<Failure, String>(tId));
    verify(() => mockRepository.getMyIdentity()).called(1);
  });
}
