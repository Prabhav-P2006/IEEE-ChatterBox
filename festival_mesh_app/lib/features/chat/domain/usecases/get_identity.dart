import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class GetIdentity extends UseCase<String, NoParams> {
  final ChatRepository repository;

  GetIdentity(this.repository);

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    try {
      final id = await repository.getMyIdentity();
      return Right(id);
    } catch (e) {
      return Left(MeshFailure(e.toString()));
    }
  }
}
