import 'dart:async';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_data_source.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/chat_models.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  
  final _chatController = StreamController<List<ChatContact>>.broadcast();
  final Map<String, ChatContact> _peers = {};

  ChatRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  }) {
    _init();
  }

  Future<void> _init() async {
    final cached = await localDataSource.getCachedContacts();
    for (var c in cached) {
      _peers[c.name] = c.toEntity();
    }
    _chatController.add(_peers.values.toList());

    remoteDataSource.onMessageReceived.listen((msgModel) async {
      await localDataSource.cacheMessage(msgModel);
      _updateChats(msgModel);
    });
  }

  void _updateChats(MessageModel msgModel) {
    // The 'peerName' is either the sender (for incoming) or the receiver (for outgoing)
    final peerName = msgModel.isMe ? msgModel.receiver : msgModel.sender;
    final msg = msgModel.toEntity();
    
    if (!_peers.containsKey(peerName)) {
      _peers[peerName] = ChatContact(
        name: peerName,
        lastMessage: msg.text,
        messages: [msg],
      );
    } else {
      final old = _peers[peerName]!;
      _peers[peerName] = old.copyWith(
        lastMessage: msg.text,
        messages: [...old.messages, msg],
      );
    }
    
    localDataSource.cacheContact(ChatContactModel(
      name: peerName,
      lastMessage: msg.text,
      messages: _peers[peerName]!.messages.map((m) => MessageModel.fromEntity(m, peerName)).toList(),
    ));

    _chatController.add(_peers.values.toList());
  }

  @override
  Future<Either<Failure, void>> sendMessage(String dest, String text) async {
    try {
      await remoteDataSource.sendMessage(dest, text);
      return const Right(null);
    } catch (e) {
      return Left(MeshFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendHandshake(String dest) async {
    try {
      await remoteDataSource.sendHandshake(dest);
      return const Right(null);
    } catch (e) {
      return Left(MeshFailure(e.toString()));
    }
  }

  @override
  Stream<Message> get messageStream => remoteDataSource.onMessageReceived.map((m) => m.toEntity());

  @override                                                                                  
  Stream<List<ChatContact>> get chatStream => _chatController.stream;

  @override
  Future<String> getMyIdentity() => remoteDataSource.getMyIdentity();

  @override
  Future<String> getSafetyNumber(String peer) => remoteDataSource.getSafetyNumber(peer);
}
                                                