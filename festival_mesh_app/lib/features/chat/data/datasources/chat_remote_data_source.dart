import 'dart:async';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/ffi/mesh_ffi.dart';
import '../models/chat_models.dart';
import 'ble_transport.dart';

abstract class ChatDataSource {
  Future<void> sendMessage(String dest, String text);
  Future<void> sendHandshake(String dest);
  Future<void> processPacket(List<int> bytes);
  Future<String> getMyIdentity();
  Future<String> getSafetyNumber(String peer);
  Stream<MessageModel> get onMessageReceived;
}

class MeshDataSourceImpl implements ChatDataSource {
  final MeshFFI _ffi = MeshFFI();
  late MeshHandle _handle;
  final String myName;

  final _messageController = StreamController<MessageModel>.broadcast();
  late final BleTransport _transport;
  
  static MeshDataSourceImpl? _instance;

  MeshDataSourceImpl(this.myName) {
    _instance = this;
    final namePtr = myName.toNativeUtf8();
    _handle = _ffi.create(namePtr);
    malloc.free(namePtr);
    
    _transport = BleTransport(onDataReceived: (bytes) {
      processPacket(bytes);
    });
    
    _setupCallbacks();
    _transport.start();
  }

  void _setupCallbacks() {
    final onMsg = NativeCallable<OnMessageCallback>.isolateLocal(_onMsgNative);
    _ffi.setOnMessage(_handle, onMsg.nativeFunction, nullptr);
    
    final onSend = NativeCallable<OnSendCallback>.isolateLocal(_onSendNative);
    _ffi.setOnSend(_handle, onSend.nativeFunction, nullptr);

    final onHs = NativeCallable<OnHandshakeCallback>.isolateLocal(_onHsNative);
    _ffi.setOnHandshake(_handle, onHs.nativeFunction, nullptr);
  }

  static void _onMsgNative(Pointer<Utf8> sender, Pointer<Utf8> text, Pointer<Void> userData) {
    final s = sender.toDartString();
    final t = text.toDartString();
    _instance?._messageController.add(MessageModel.fromFfi(s, _instance!.myName, t, false));
  }

  static void _onSendNative(Pointer<Uint8> data, int len, Pointer<Void> userData) {
    final bytes = data.asTypedList(len).toList();
    _instance?._transport.broadcast(bytes);
  }

  static void _onHsNative(Pointer<Utf8> sender, Pointer<Void> userData) {
    final s = sender.toDartString();
    debugPrint("FFI HS COMPLETE: Session established with $s");
  }

  @override
  Future<void> sendMessage(String dest, String text) async {
    final destPtr = dest.toNativeUtf8();
    final textPtr = text.toNativeUtf8();
    _ffi.sendMessage(_handle, destPtr, textPtr);
    malloc.free(destPtr);
    malloc.free(textPtr);
    
    _messageController.add(MessageModel.fromFfi(myName, dest, text, true));
  }

  @override
  Future<void> sendHandshake(String dest) async {
    final destPtr = dest.toNativeUtf8();
    _ffi.sendHandshake(_handle, destPtr);
    malloc.free(destPtr);
  }

  @override
  Future<void> processPacket(List<int> bytes) async {
    final ptr = malloc<Uint8>(bytes.length);
    ptr.asTypedList(bytes.length).setAll(0, bytes);
    _ffi.processPacket(_handle, ptr, bytes.length);
    malloc.free(ptr);
  }

  @override
  Future<String> getMyIdentity() async => _ffi.getPublicKeyHex(_handle).toDartString();

  @override
  Future<String> getSafetyNumber(String peer) async {
    final peerPtr = peer.toNativeUtf8();
    final sn = _ffi.getSafetyNumber(_handle, peerPtr).toDartString();
    malloc.free(peerPtr);
    return sn;
  }

  @override
  Stream<MessageModel> get onMessageReceived => _messageController.stream;
}
