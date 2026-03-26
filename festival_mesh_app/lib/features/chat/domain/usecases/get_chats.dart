import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';
import '../entities/chat_entities.dart';

class GetChats extends UseCase<Stream<List<ChatContact>>, NoParams> {
  final ChatRepository repository;

  GetChats(this.repository);

  @override
  Future<Either<Failure, Stream<List<ChatContact>>>> call(NoParams params) async {
    return Right(repository.chatStream);
  }
}
