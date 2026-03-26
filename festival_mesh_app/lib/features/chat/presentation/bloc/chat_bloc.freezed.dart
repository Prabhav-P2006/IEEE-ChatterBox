// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ChatEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(String dest, String text) messageSent,
    required TResult Function(String dest) handshakeSent,
    required TResult Function(List<ChatContact> chats) chatsUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(String dest, String text)? messageSent,
    TResult? Function(String dest)? handshakeSent,
    TResult? Function(List<ChatContact> chats)? chatsUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(String dest, String text)? messageSent,
    TResult Function(String dest)? handshakeSent,
    TResult Function(List<ChatContact> chats)? chatsUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatStarted value) started,
    required TResult Function(ChatMessageSent value) messageSent,
    required TResult Function(ChatHandshakeSent value) handshakeSent,
    required TResult Function(ChatChatsUpdated value) chatsUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatStarted value)? started,
    TResult? Function(ChatMessageSent value)? messageSent,
    TResult? Function(ChatHandshakeSent value)? handshakeSent,
    TResult? Function(ChatChatsUpdated value)? chatsUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatStarted value)? started,
    TResult Function(ChatMessageSent value)? messageSent,
    TResult Function(ChatHandshakeSent value)? handshakeSent,
    TResult Function(ChatChatsUpdated value)? chatsUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatEventCopyWith<$Res> {
  factory $ChatEventCopyWith(ChatEvent value, $Res Function(ChatEvent) then) =
      _$ChatEventCopyWithImpl<$Res, ChatEvent>;
}

/// @nodoc
class _$ChatEventCopyWithImpl<$Res, $Val extends ChatEvent>
    implements $ChatEventCopyWith<$Res> {
  _$ChatEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ChatStartedImplCopyWith<$Res> {
  factory _$$ChatStartedImplCopyWith(
          _$ChatStartedImpl value, $Res Function(_$ChatStartedImpl) then) =
      __$$ChatStartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChatStartedImplCopyWithImpl<$Res>
    extends _$ChatEventCopyWithImpl<$Res, _$ChatStartedImpl>
    implements _$$ChatStartedImplCopyWith<$Res> {
  __$$ChatStartedImplCopyWithImpl(
      _$ChatStartedImpl _value, $Res Function(_$ChatStartedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ChatStartedImpl implements ChatStarted {
  const _$ChatStartedImpl();

  @override
  String toString() {
    return 'ChatEvent.started()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ChatStartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(String dest, String text) messageSent,
    required TResult Function(String dest) handshakeSent,
    required TResult Function(List<ChatContact> chats) chatsUpdated,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(String dest, String text)? messageSent,
    TResult? Function(String dest)? handshakeSent,
    TResult? Function(List<ChatContact> chats)? chatsUpdated,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(String dest, String text)? messageSent,
    TResult Function(String dest)? handshakeSent,
    TResult Function(List<ChatContact> chats)? chatsUpdated,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatStarted value) started,
    required TResult Function(ChatMessageSent value) messageSent,
    required TResult Function(ChatHandshakeSent value) handshakeSent,
    required TResult Function(ChatChatsUpdated value) chatsUpdated,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatStarted value)? started,
    TResult? Function(ChatMessageSent value)? messageSent,
    TResult? Function(ChatHandshakeSent value)? handshakeSent,
    TResult? Function(ChatChatsUpdated value)? chatsUpdated,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatStarted value)? started,
    TResult Function(ChatMessageSent value)? messageSent,
    TResult Function(ChatHandshakeSent value)? handshakeSent,
    TResult Function(ChatChatsUpdated value)? chatsUpdated,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class ChatStarted implements ChatEvent {
  const factory ChatStarted() = _$ChatStartedImpl;
}

/// @nodoc
abstract class _$$ChatMessageSentImplCopyWith<$Res> {
  factory _$$ChatMessageSentImplCopyWith(_$ChatMessageSentImpl value,
          $Res Function(_$ChatMessageSentImpl) then) =
      __$$ChatMessageSentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String dest, String text});
}

/// @nodoc
class __$$ChatMessageSentImplCopyWithImpl<$Res>
    extends _$ChatEventCopyWithImpl<$Res, _$ChatMessageSentImpl>
    implements _$$ChatMessageSentImplCopyWith<$Res> {
  __$$ChatMessageSentImplCopyWithImpl(
      _$ChatMessageSentImpl _value, $Res Function(_$ChatMessageSentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dest = null,
    Object? text = null,
  }) {
    return _then(_$ChatMessageSentImpl(
      null == dest
          ? _value.dest
          : dest // ignore: cast_nullable_to_non_nullable
              as String,
      null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ChatMessageSentImpl implements ChatMessageSent {
  const _$ChatMessageSentImpl(this.dest, this.text);

  @override
  final String dest;
  @override
  final String text;

  @override
  String toString() {
    return 'ChatEvent.messageSent(dest: $dest, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatMessageSentImpl &&
            (identical(other.dest, dest) || other.dest == dest) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dest, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatMessageSentImplCopyWith<_$ChatMessageSentImpl> get copyWith =>
      __$$ChatMessageSentImplCopyWithImpl<_$ChatMessageSentImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(String dest, String text) messageSent,
    required TResult Function(String dest) handshakeSent,
    required TResult Function(List<ChatContact> chats) chatsUpdated,
  }) {
    return messageSent(dest, text);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(String dest, String text)? messageSent,
    TResult? Function(String dest)? handshakeSent,
    TResult? Function(List<ChatContact> chats)? chatsUpdated,
  }) {
    return messageSent?.call(dest, text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(String dest, String text)? messageSent,
    TResult Function(String dest)? handshakeSent,
    TResult Function(List<ChatContact> chats)? chatsUpdated,
    required TResult orElse(),
  }) {
    if (messageSent != null) {
      return messageSent(dest, text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatStarted value) started,
    required TResult Function(ChatMessageSent value) messageSent,
    required TResult Function(ChatHandshakeSent value) handshakeSent,
    required TResult Function(ChatChatsUpdated value) chatsUpdated,
  }) {
    return messageSent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatStarted value)? started,
    TResult? Function(ChatMessageSent value)? messageSent,
    TResult? Function(ChatHandshakeSent value)? handshakeSent,
    TResult? Function(ChatChatsUpdated value)? chatsUpdated,
  }) {
    return messageSent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatStarted value)? started,
    TResult Function(ChatMessageSent value)? messageSent,
    TResult Function(ChatHandshakeSent value)? handshakeSent,
    TResult Function(ChatChatsUpdated value)? chatsUpdated,
    required TResult orElse(),
  }) {
    if (messageSent != null) {
      return messageSent(this);
    }
    return orElse();
  }
}

abstract class ChatMessageSent implements ChatEvent {
  const factory ChatMessageSent(final String dest, final String text) =
      _$ChatMessageSentImpl;

  String get dest;
  String get text;
  @JsonKey(ignore: true)
  _$$ChatMessageSentImplCopyWith<_$ChatMessageSentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChatHandshakeSentImplCopyWith<$Res> {
  factory _$$ChatHandshakeSentImplCopyWith(_$ChatHandshakeSentImpl value,
          $Res Function(_$ChatHandshakeSentImpl) then) =
      __$$ChatHandshakeSentImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String dest});
}

/// @nodoc
class __$$ChatHandshakeSentImplCopyWithImpl<$Res>
    extends _$ChatEventCopyWithImpl<$Res, _$ChatHandshakeSentImpl>
    implements _$$ChatHandshakeSentImplCopyWith<$Res> {
  __$$ChatHandshakeSentImplCopyWithImpl(_$ChatHandshakeSentImpl _value,
      $Res Function(_$ChatHandshakeSentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dest = null,
  }) {
    return _then(_$ChatHandshakeSentImpl(
      null == dest
          ? _value.dest
          : dest // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ChatHandshakeSentImpl implements ChatHandshakeSent {
  const _$ChatHandshakeSentImpl(this.dest);

  @override
  final String dest;

  @override
  String toString() {
    return 'ChatEvent.handshakeSent(dest: $dest)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatHandshakeSentImpl &&
            (identical(other.dest, dest) || other.dest == dest));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dest);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatHandshakeSentImplCopyWith<_$ChatHandshakeSentImpl> get copyWith =>
      __$$ChatHandshakeSentImplCopyWithImpl<_$ChatHandshakeSentImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(String dest, String text) messageSent,
    required TResult Function(String dest) handshakeSent,
    required TResult Function(List<ChatContact> chats) chatsUpdated,
  }) {
    return handshakeSent(dest);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(String dest, String text)? messageSent,
    TResult? Function(String dest)? handshakeSent,
    TResult? Function(List<ChatContact> chats)? chatsUpdated,
  }) {
    return handshakeSent?.call(dest);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(String dest, String text)? messageSent,
    TResult Function(String dest)? handshakeSent,
    TResult Function(List<ChatContact> chats)? chatsUpdated,
    required TResult orElse(),
  }) {
    if (handshakeSent != null) {
      return handshakeSent(dest);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatStarted value) started,
    required TResult Function(ChatMessageSent value) messageSent,
    required TResult Function(ChatHandshakeSent value) handshakeSent,
    required TResult Function(ChatChatsUpdated value) chatsUpdated,
  }) {
    return handshakeSent(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatStarted value)? started,
    TResult? Function(ChatMessageSent value)? messageSent,
    TResult? Function(ChatHandshakeSent value)? handshakeSent,
    TResult? Function(ChatChatsUpdated value)? chatsUpdated,
  }) {
    return handshakeSent?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatStarted value)? started,
    TResult Function(ChatMessageSent value)? messageSent,
    TResult Function(ChatHandshakeSent value)? handshakeSent,
    TResult Function(ChatChatsUpdated value)? chatsUpdated,
    required TResult orElse(),
  }) {
    if (handshakeSent != null) {
      return handshakeSent(this);
    }
    return orElse();
  }
}

abstract class ChatHandshakeSent implements ChatEvent {
  const factory ChatHandshakeSent(final String dest) = _$ChatHandshakeSentImpl;

  String get dest;
  @JsonKey(ignore: true)
  _$$ChatHandshakeSentImplCopyWith<_$ChatHandshakeSentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChatChatsUpdatedImplCopyWith<$Res> {
  factory _$$ChatChatsUpdatedImplCopyWith(_$ChatChatsUpdatedImpl value,
          $Res Function(_$ChatChatsUpdatedImpl) then) =
      __$$ChatChatsUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<ChatContact> chats});
}

/// @nodoc
class __$$ChatChatsUpdatedImplCopyWithImpl<$Res>
    extends _$ChatEventCopyWithImpl<$Res, _$ChatChatsUpdatedImpl>
    implements _$$ChatChatsUpdatedImplCopyWith<$Res> {
  __$$ChatChatsUpdatedImplCopyWithImpl(_$ChatChatsUpdatedImpl _value,
      $Res Function(_$ChatChatsUpdatedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chats = null,
  }) {
    return _then(_$ChatChatsUpdatedImpl(
      null == chats
          ? _value._chats
          : chats // ignore: cast_nullable_to_non_nullable
              as List<ChatContact>,
    ));
  }
}

/// @nodoc

class _$ChatChatsUpdatedImpl implements ChatChatsUpdated {
  const _$ChatChatsUpdatedImpl(final List<ChatContact> chats) : _chats = chats;

  final List<ChatContact> _chats;
  @override
  List<ChatContact> get chats {
    if (_chats is EqualUnmodifiableListView) return _chats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chats);
  }

  @override
  String toString() {
    return 'ChatEvent.chatsUpdated(chats: $chats)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatChatsUpdatedImpl &&
            const DeepCollectionEquality().equals(other._chats, _chats));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_chats));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatChatsUpdatedImplCopyWith<_$ChatChatsUpdatedImpl> get copyWith =>
      __$$ChatChatsUpdatedImplCopyWithImpl<_$ChatChatsUpdatedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(String dest, String text) messageSent,
    required TResult Function(String dest) handshakeSent,
    required TResult Function(List<ChatContact> chats) chatsUpdated,
  }) {
    return chatsUpdated(chats);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(String dest, String text)? messageSent,
    TResult? Function(String dest)? handshakeSent,
    TResult? Function(List<ChatContact> chats)? chatsUpdated,
  }) {
    return chatsUpdated?.call(chats);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(String dest, String text)? messageSent,
    TResult Function(String dest)? handshakeSent,
    TResult Function(List<ChatContact> chats)? chatsUpdated,
    required TResult orElse(),
  }) {
    if (chatsUpdated != null) {
      return chatsUpdated(chats);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatStarted value) started,
    required TResult Function(ChatMessageSent value) messageSent,
    required TResult Function(ChatHandshakeSent value) handshakeSent,
    required TResult Function(ChatChatsUpdated value) chatsUpdated,
  }) {
    return chatsUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatStarted value)? started,
    TResult? Function(ChatMessageSent value)? messageSent,
    TResult? Function(ChatHandshakeSent value)? handshakeSent,
    TResult? Function(ChatChatsUpdated value)? chatsUpdated,
  }) {
    return chatsUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatStarted value)? started,
    TResult Function(ChatMessageSent value)? messageSent,
    TResult Function(ChatHandshakeSent value)? handshakeSent,
    TResult Function(ChatChatsUpdated value)? chatsUpdated,
    required TResult orElse(),
  }) {
    if (chatsUpdated != null) {
      return chatsUpdated(this);
    }
    return orElse();
  }
}

abstract class ChatChatsUpdated implements ChatEvent {
  const factory ChatChatsUpdated(final List<ChatContact> chats) =
      _$ChatChatsUpdatedImpl;

  List<ChatContact> get chats;
  @JsonKey(ignore: true)
  _$$ChatChatsUpdatedImplCopyWith<_$ChatChatsUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ChatState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<ChatContact> chats, String myId, String myName, String? error)
        loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<ChatContact> chats, String myId, String myName, String? error)?
        loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<ChatContact> chats, String myId, String myName, String? error)?
        loaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatInitial value) initial,
    required TResult Function(ChatLoading value) loading,
    required TResult Function(ChatLoaded value) loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatInitial value)? initial,
    TResult? Function(ChatLoading value)? loading,
    TResult? Function(ChatLoaded value)? loaded,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatInitial value)? initial,
    TResult Function(ChatLoading value)? loading,
    TResult Function(ChatLoaded value)? loaded,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatStateCopyWith<$Res> {
  factory $ChatStateCopyWith(ChatState value, $Res Function(ChatState) then) =
      _$ChatStateCopyWithImpl<$Res, ChatState>;
}

/// @nodoc
class _$ChatStateCopyWithImpl<$Res, $Val extends ChatState>
    implements $ChatStateCopyWith<$Res> {
  _$ChatStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ChatInitialImplCopyWith<$Res> {
  factory _$$ChatInitialImplCopyWith(
          _$ChatInitialImpl value, $Res Function(_$ChatInitialImpl) then) =
      __$$ChatInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChatInitialImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatInitialImpl>
    implements _$$ChatInitialImplCopyWith<$Res> {
  __$$ChatInitialImplCopyWithImpl(
      _$ChatInitialImpl _value, $Res Function(_$ChatInitialImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ChatInitialImpl implements ChatInitial {
  const _$ChatInitialImpl();

  @override
  String toString() {
    return 'ChatState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ChatInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<ChatContact> chats, String myId, String myName, String? error)
        loaded,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<ChatContact> chats, String myId, String myName, String? error)?
        loaded,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<ChatContact> chats, String myId, String myName, String? error)?
        loaded,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatInitial value) initial,
    required TResult Function(ChatLoading value) loading,
    required TResult Function(ChatLoaded value) loaded,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatInitial value)? initial,
    TResult? Function(ChatLoading value)? loading,
    TResult? Function(ChatLoaded value)? loaded,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatInitial value)? initial,
    TResult Function(ChatLoading value)? loading,
    TResult Function(ChatLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class ChatInitial implements ChatState {
  const factory ChatInitial() = _$ChatInitialImpl;
}

/// @nodoc
abstract class _$$ChatLoadingImplCopyWith<$Res> {
  factory _$$ChatLoadingImplCopyWith(
          _$ChatLoadingImpl value, $Res Function(_$ChatLoadingImpl) then) =
      __$$ChatLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ChatLoadingImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatLoadingImpl>
    implements _$$ChatLoadingImplCopyWith<$Res> {
  __$$ChatLoadingImplCopyWithImpl(
      _$ChatLoadingImpl _value, $Res Function(_$ChatLoadingImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ChatLoadingImpl implements ChatLoading {
  const _$ChatLoadingImpl();

  @override
  String toString() {
    return 'ChatState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ChatLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<ChatContact> chats, String myId, String myName, String? error)
        loaded,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<ChatContact> chats, String myId, String myName, String? error)?
        loaded,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<ChatContact> chats, String myId, String myName, String? error)?
        loaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatInitial value) initial,
    required TResult Function(ChatLoading value) loading,
    required TResult Function(ChatLoaded value) loaded,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatInitial value)? initial,
    TResult? Function(ChatLoading value)? loading,
    TResult? Function(ChatLoaded value)? loaded,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatInitial value)? initial,
    TResult Function(ChatLoading value)? loading,
    TResult Function(ChatLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class ChatLoading implements ChatState {
  const factory ChatLoading() = _$ChatLoadingImpl;
}

/// @nodoc
abstract class _$$ChatLoadedImplCopyWith<$Res> {
  factory _$$ChatLoadedImplCopyWith(
          _$ChatLoadedImpl value, $Res Function(_$ChatLoadedImpl) then) =
      __$$ChatLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<ChatContact> chats, String myId, String myName, String? error});
}

/// @nodoc
class __$$ChatLoadedImplCopyWithImpl<$Res>
    extends _$ChatStateCopyWithImpl<$Res, _$ChatLoadedImpl>
    implements _$$ChatLoadedImplCopyWith<$Res> {
  __$$ChatLoadedImplCopyWithImpl(
      _$ChatLoadedImpl _value, $Res Function(_$ChatLoadedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? chats = null,
    Object? myId = null,
    Object? myName = null,
    Object? error = freezed,
  }) {
    return _then(_$ChatLoadedImpl(
      chats: null == chats
          ? _value._chats
          : chats // ignore: cast_nullable_to_non_nullable
              as List<ChatContact>,
      myId: null == myId
          ? _value.myId
          : myId // ignore: cast_nullable_to_non_nullable
              as String,
      myName: null == myName
          ? _value.myName
          : myName // ignore: cast_nullable_to_non_nullable
              as String,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ChatLoadedImpl implements ChatLoaded {
  const _$ChatLoadedImpl(
      {required final List<ChatContact> chats,
      required this.myId,
      required this.myName,
      this.error})
      : _chats = chats;

  final List<ChatContact> _chats;
  @override
  List<ChatContact> get chats {
    if (_chats is EqualUnmodifiableListView) return _chats;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_chats);
  }

  @override
  final String myId;
  @override
  final String myName;
  @override
  final String? error;

  @override
  String toString() {
    return 'ChatState.loaded(chats: $chats, myId: $myId, myName: $myName, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatLoadedImpl &&
            const DeepCollectionEquality().equals(other._chats, _chats) &&
            (identical(other.myId, myId) || other.myId == myId) &&
            (identical(other.myName, myName) || other.myName == myName) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_chats), myId, myName, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatLoadedImplCopyWith<_$ChatLoadedImpl> get copyWith =>
      __$$ChatLoadedImplCopyWithImpl<_$ChatLoadedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<ChatContact> chats, String myId, String myName, String? error)
        loaded,
  }) {
    return loaded(chats, myId, myName, error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<ChatContact> chats, String myId, String myName, String? error)?
        loaded,
  }) {
    return loaded?.call(chats, myId, myName, error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<ChatContact> chats, String myId, String myName, String? error)?
        loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(chats, myId, myName, error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ChatInitial value) initial,
    required TResult Function(ChatLoading value) loading,
    required TResult Function(ChatLoaded value) loaded,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ChatInitial value)? initial,
    TResult? Function(ChatLoading value)? loading,
    TResult? Function(ChatLoaded value)? loaded,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ChatInitial value)? initial,
    TResult Function(ChatLoading value)? loading,
    TResult Function(ChatLoaded value)? loaded,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class ChatLoaded implements ChatState {
  const factory ChatLoaded(
      {required final List<ChatContact> chats,
      required final String myId,
      required final String myName,
      final String? error}) = _$ChatLoadedImpl;

  List<ChatContact> get chats;
  String get myId;
  String get myName;
  String? get error;
  @JsonKey(ignore: true)
  _$$ChatLoadedImplCopyWith<_$ChatLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
