import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class SendHandshake extends UseCase<void, String> {
  final ChatRepository repository;

  SendHandshake(this.repository);

  @override
  Future<Either<Failure, void>> call(String dest) async {
    return await repository.sendHandshake(dest);
  }
}
