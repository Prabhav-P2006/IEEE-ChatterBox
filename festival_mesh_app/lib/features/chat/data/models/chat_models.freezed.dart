// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) {
  return _MessageModel.fromJson(json);
}

/// @nodoc
mixin _$MessageModel {
  String get sender => throw _privateConstructorUsedError;
  String get receiver =>
      throw _privateConstructorUsedError; // Added to track destination for 'isMe' messages
  String get text => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  bool get isMe => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MessageModelCopyWith<MessageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageModelCopyWith<$Res> {
  factory $MessageModelCopyWith(
          MessageModel value, $Res Function(MessageModel) then) =
      _$MessageModelCopyWithImpl<$Res, MessageModel>;
  @useResult
  $Res call(
      {String sender,
      String receiver,
      String text,
      DateTime timestamp,
      bool isMe});
}

/// @nodoc
class _$MessageModelCopyWithImpl<$Res, $Val extends MessageModel>
    implements $MessageModelCopyWith<$Res> {
  _$MessageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sender = null,
    Object? receiver = null,
    Object? text = null,
    Object? timestamp = null,
    Object? isMe = null,
  }) {
    return _then(_value.copyWith(
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MessageModelImplCopyWith<$Res>
    implements $MessageModelCopyWith<$Res> {
  factory _$$MessageModelImplCopyWith(
          _$MessageModelImpl value, $Res Function(_$MessageModelImpl) then) =
      __$$MessageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sender,
      String receiver,
      String text,
      DateTime timestamp,
      bool isMe});
}

/// @nodoc
class __$$MessageModelImplCopyWithImpl<$Res>
    extends _$MessageModelCopyWithImpl<$Res, _$MessageModelImpl>
    implements _$$MessageModelImplCopyWith<$Res> {
  __$$MessageModelImplCopyWithImpl(
      _$MessageModelImpl _value, $Res Function(_$MessageModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sender = null,
    Object? receiver = null,
    Object? text = null,
    Object? timestamp = null,
    Object? isMe = null,
  }) {
    return _then(_$MessageModelImpl(
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isMe: null == isMe
          ? _value.isMe
          : isMe // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageModelImpl implements _MessageModel {
  const _$MessageModelImpl(
      {required this.sender,
      required this.receiver,
      required this.text,
      required this.timestamp,
      required this.isMe});

  factory _$MessageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageModelImplFromJson(json);

  @override
  final String sender;
  @override
  final String receiver;
// Added to track destination for 'isMe' messages
  @override
  final String text;
  @override
  final DateTime timestamp;
  @override
  final bool isMe;

  @override
  String toString() {
    return 'MessageModel(sender: $sender, receiver: $receiver, text: $text, timestamp: $timestamp, isMe: $isMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageModelImpl &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.isMe, isMe) || other.isMe == isMe));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, sender, receiver, text, timestamp, isMe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      __$$MessageModelImplCopyWithImpl<_$MessageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageModelImplToJson(
      this,
    );
  }
}

abstract class _MessageModel implements MessageModel {
  const factory _MessageModel(
      {required final String sender,
      required final String receiver,
      required final String text,
      required final DateTime timestamp,
      required final bool isMe}) = _$MessageModelImpl;

  factory _MessageModel.fromJson(Map<String, dynamic> json) =
      _$MessageModelImpl.fromJson;

  @override
  String get sender;
  @override
  String get receiver;
  @override // Added to track destination for 'isMe' messages
  String get text;
  @override
  DateTime get timestamp;
  @override
  bool get isMe;
  @override
  @JsonKey(ignore: true)
  _$$MessageModelImplCopyWith<_$MessageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChatContactModel _$ChatContactModelFromJson(Map<String, dynamic> json) {
  return _ChatContactModel.fromJson(json);
}

/// @nodoc
mixin _$ChatContactModel {
  String get name => throw _privateConstructorUsedError;
  String get lastMessage => throw _privateConstructorUsedError;
  List<MessageModel> get messages => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChatContactModelCopyWith<ChatContactModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatContactModelCopyWith<$Res> {
  factory $ChatContactModelCopyWith(
          ChatContactModel value, $Res Function(ChatContactModel) then) =
      _$ChatContactModelCopyWithImpl<$Res, ChatContactModel>;
  @useResult
  $Res call({String name, String lastMessage, List<MessageModel> messages});
}

/// @nodoc
class _$ChatContactModelCopyWithImpl<$Res, $Val extends ChatContactModel>
    implements $ChatContactModelCopyWith<$Res> {
  _$ChatContactModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? lastMessage = null,
    Object? messages = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value.messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChatContactModelImplCopyWith<$Res>
    implements $ChatContactModelCopyWith<$Res> {
  factory _$$ChatContactModelImplCopyWith(_$ChatContactModelImpl value,
          $Res Function(_$ChatContactModelImpl) then) =
      __$$ChatContactModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String lastMessage, List<MessageModel> messages});
}

/// @nodoc
class __$$ChatContactModelImplCopyWithImpl<$Res>
    extends _$ChatContactModelCopyWithImpl<$Res, _$ChatContactModelImpl>
    implements _$$ChatContactModelImplCopyWith<$Res> {
  __$$ChatContactModelImplCopyWithImpl(_$ChatContactModelImpl _value,
      $Res Function(_$ChatContactModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? lastMessage = null,
    Object? messages = null,
  }) {
    return _then(_$ChatContactModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      lastMessage: null == lastMessage
          ? _value.lastMessage
          : lastMessage // ignore: cast_nullable_to_non_nullable
              as String,
      messages: null == messages
          ? _value._messages
          : messages // ignore: cast_nullable_to_non_nullable
              as List<MessageModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChatContactModelImpl implements _ChatContactModel {
  const _$ChatContactModelImpl(
      {required this.name,
      required this.lastMessage,
      required final List<MessageModel> messages})
      : _messages = messages;

  factory _$ChatContactModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChatContactModelImplFromJson(json);

  @override
  final String name;
  @override
  final String lastMessage;
  final List<MessageModel> _messages;
  @override
  List<MessageModel> get messages {
    if (_messages is EqualUnmodifiableListView) return _messages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_messages);
  }

  @override
  String toString() {
    return 'ChatContactModel(name: $name, lastMessage: $lastMessage, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatContactModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            const DeepCollectionEquality().equals(other._messages, _messages));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, lastMessage,
      const DeepCollectionEquality().hash(_messages));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatContactModelImplCopyWith<_$ChatContactModelImpl> get copyWith =>
      __$$ChatContactModelImplCopyWithImpl<_$ChatContactModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChatContactModelImplToJson(
      this,
    );
  }
}

abstract class _ChatContactModel implements ChatContactModel {
  const factory _ChatContactModel(
      {required final String name,
      required final String lastMessage,
      required final List<MessageModel> messages}) = _$ChatContactModelImpl;

  factory _ChatContactModel.fromJson(Map<String, dynamic> json) =
      _$ChatContactModelImpl.fromJson;

  @override
  String get name;
  @override
  String get lastMessage;
  @override
  List<MessageModel> get messages;
  @override
  @JsonKey(ignore: true)
  _$$ChatContactModelImplCopyWith<_$ChatContactModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
