import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/chat_repository.dart';

class SendMessage extends UseCase<void, SendMessageParams> {
  final ChatRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, void>> call(SendMessageParams params) async {
    return await repository.sendMessage(params.dest, params.text);
  }
}

class SendMessageParams extends Equatable {
  final String dest;
  final String text;

  const SendMessageParams({required this.dest, required this.text});

  @override
  List<Object?> get props => [dest, text];
}
