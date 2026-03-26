import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/chat_entities.dart';

abstract class ChatRepository {
  Future<Either<Failure, void>> sendMessage(String dest, String text);
  Future<Either<Failure, void>> sendHandshake(String dest);
  Stream<Message> get messageStream;
  Stream<List<ChatContact>> get chatStream;
  Future<String> getMyIdentity();
  Future<String> getSafetyNumber(String peer);
}
