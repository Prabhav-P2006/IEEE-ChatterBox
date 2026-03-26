import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';
import '../entities/chat_entities.dart';

class GetMessages extends UseCase<Stream<Message>, NoParams> {
  final ChatRepository repository;

  GetMessages(this.repository);

  @override
  Future<Either<Failure, Stream<Message>>> call(NoParams params) async {
    return Right(repository.messageStream);
  }
}
