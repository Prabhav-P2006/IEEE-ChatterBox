import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/chat_entities.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/send_handshake.dart';
import '../../domain/usecases/get_chats.dart';
import '../../domain/usecases/get_identity.dart';
import '../../data/datasources/chat_remote_data_source.dart';
import '../../../../injection_container.dart' as di;
import '../../../../core/usecases/usecase.dart';

part 'chat_bloc.freezed.dart';

@freezed
sealed class ChatEvent with _$ChatEvent {
  const factory ChatEvent.started() = ChatStarted;
  const factory ChatEvent.messageSent(String dest, String text) = ChatMessageSent;
  const factory ChatEvent.handshakeSent(String dest) = ChatHandshakeSent;
  const factory ChatEvent.chatsUpdated(List<ChatContact> chats) = ChatChatsUpdated;
}

@freezed
sealed class ChatState with _$ChatState {
  const factory ChatState.initial() = ChatInitial;
  const factory ChatState.loading() = ChatLoading;
  const factory ChatState.loaded({
    required List<ChatContact> chats,
    required String myId,
    required String myName,
    String? error,
  }) = ChatLoaded;
}

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessage sendMessage;
  final SendHandshake sendHandshake;
  final GetChats getChats;
  final GetIdentity getIdentity;

  ChatBloc({
    required this.sendMessage,
    required this.sendHandshake,
    required this.getChats,
    required this.getIdentity,
  }) : super(const ChatInitial()) {
    on<ChatStarted>(_onStarted);
    on<ChatMessageSent>(_onMessageSent);
    on<ChatHandshakeSent>(_onHandshakeSent);
    on<ChatChatsUpdated>(_onChatsUpdated);
  }

  Future<void> _onStarted(ChatStarted event, Emitter<ChatState> emit) async {
    emit(const ChatLoading());
    final idResult = await getIdentity(NoParams());
    final chatsResult = await getChats(NoParams());

    String myId = "Unknown";
    idResult.fold((l) => null, (r) => myId = r);
    final String myName = (di.sl<ChatDataSource>() as MeshDataSourceImpl).myName;

    chatsResult.fold(
      (l) => emit(ChatLoaded(chats: [], myId: myId, myName: myName, error: l.message)),
      (stream) {
        stream.listen((chats) {
          add(ChatChatsUpdated(chats));
        });
        emit(ChatLoaded(chats: [], myId: myId, myName: myName));
      },
    );
  }

  Future<void> _onMessageSent(ChatMessageSent event, Emitter<ChatState> emit) async {
    await sendMessage(SendMessageParams(dest: event.dest, text: event.text));
  }

  Future<void> _onHandshakeSent(ChatHandshakeSent event, Emitter<ChatState> emit) async {
    await sendHandshake(event.dest);
  }

  void _onChatsUpdated(ChatChatsUpdated event, Emitter<ChatState> emit) {
    final currentState = state;
    if (currentState is ChatLoaded) {
      emit(currentState.copyWith(chats: event.chats));
    }
  }
}
