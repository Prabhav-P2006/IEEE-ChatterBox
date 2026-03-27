import 'dart:async';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'package:festival_mesh_app/core/utils/mesh_logger.dart';
import '../../../../core/ffi/mesh_ffi.dart';
import '../models/chat_models.dart';
import 'ble_transport.dart';

abstract class ChatDataSource {
  Future<void> sendMessage(String dest, String text);
  Future<void> sendHandshake(String dest);
  Future<void> processPacket(List<int> bytes);
  void spawnMockPeer();
  Future<void> updateMyName(String newName);
  Future<String> getMyIdentity();
  Future<String> getSafetyNumber(String peer);
  Stream<MessageModel> get onMessageReceived;
}

class MeshDataSourceImpl implements ChatDataSource {
  final MeshFFI _ffi = MeshFFI();
  late MeshHandle _handle;
  String myName;

  MeshHandle? _mockBobHandle;

  @override
  @override
  void spawnMockPeer() {
    final namePtr = "MockBob".toNativeUtf8();
    _mockBobHandle = _ffi.create(namePtr);
    malloc.free(namePtr);

    // Set Bob's callbacks too
    _ffi.setOnMessage(_mockBobHandle!, _onMsgCallable.nativeFunction, Pointer.fromAddress(1));
    _ffi.setOnSend(_mockBobHandle!, _onSendCallable.nativeFunction, Pointer.fromAddress(1));
    _ffi.setOnHandshake(_mockBobHandle!, _onHsCallable.nativeFunction, Pointer.fromAddress(1));

    sendHandshake("MockBob");

    // Auto-reply greeting from Bob to Alice
    Future.delayed(const Duration(seconds: 2), () {
      if (_mockBobHandle != null) {
        final destPtr = myName.toNativeUtf8();
        final msgPtr = "Greetings! The C++ Mesh Engine is working with Monocypher 🚀".toNativeUtf8();
        _ffi.sendMessage(_mockBobHandle!, destPtr, msgPtr);
        malloc.free(destPtr);
        malloc.free(msgPtr);
      }
    });
  }

  @override
  Future<void> updateMyName(String newName) async {
    myName = newName;
  }

  final _messageController = StreamController<MessageModel>.broadcast();
  late final BleTransport _transport;

  static MeshDataSourceImpl? _instance;

  // Keep Callbacks alive
  late final NativeCallable<OnMessageCallback> _onMsgCallable;
  late final NativeCallable<OnSendCallback> _onSendCallable;
  late final NativeCallable<OnHandshakeCallback> _onHsCallable;

  MeshDataSourceImpl(this.myName) {
    print("💎 MeshDataSourceImpl: INITIALIZING node '$myName'...");
    _instance = this;
    final namePtr = myName.toNativeUtf8();
    _handle = _ffi.create(namePtr);
    malloc.free(namePtr);
    print("💎 MeshHandle created: $_handle");

    _onMsgCallable = NativeCallable<OnMessageCallback>.isolateLocal(
      _onMsgNative,
    );
    _onSendCallable = NativeCallable<OnSendCallback>.isolateLocal(
      _onSendNative,
    );
    _onHsCallable = NativeCallable<OnHandshakeCallback>.isolateLocal(
      _onHsNative,
    );

    _transport = BleTransport(
      onDataReceived: (bytes) {
        processPacket(bytes);
      },
    );

    _initCallbacks();
    _transport.start();
  }

  void _initCallbacks() {
    _ffi.setOnMessage(_handle, _onMsgCallable.nativeFunction, Pointer.fromAddress(0));
    _ffi.setOnSend(_handle, _onSendCallable.nativeFunction, Pointer.fromAddress(0));
    _ffi.setOnHandshake(_handle, _onHsCallable.nativeFunction, Pointer.fromAddress(0));
  }

  static void _onMsgNative(
    Pointer<Utf8> sender,
    Pointer<Utf8> text,
    Pointer<Void> userData,
  ) {
    // Only Alice (main handle) adds to the UI stream
    if (userData.address != 0) return;

    final s = sender.toDartString();
    final t = text.toDartString();
    _instance?._messageController.add(
      MessageModel.fromFfi(s, _instance!.myName, t, false),
    );
  }

  static void _onSendNative(
    Pointer<Uint8> data,
    int len,
    Pointer<Void> userData,
  ) {
    final bytes = data.asTypedList(len).toList();
    final isBob = userData.address == 1;

    // We only broadcast from the main handle to the real world
    if (!isBob) {
      _instance?._transport.broadcast(bytes);
    }

    MeshLogger().log("📡 [${isBob ? 'BOB' : 'Alice'}] Mesh packet (${len} bytes)");

    // LOOPBACK simulation for single-device testing:
    if (_instance != null) {
      Future.delayed(const Duration(milliseconds: 50), () {
        final ptr = malloc<Uint8>(len);
        ptr.asTypedList(len).setAll(0, bytes);

        if (!isBob) {
          // Alice -> Bob
          if (_instance!._mockBobHandle != null) {
            _instance!._ffi.processPacket(_instance!._mockBobHandle!, ptr, len);
          }
        } else {
          // Bob -> Alice
          _instance!._ffi.processPacket(_instance!._handle, ptr, len);
        }

        malloc.free(ptr);
      });
    }
  }

  static void _onHsNative(Pointer<Utf8> sender, Pointer<Void> userData) {
    final s = sender.toDartString();
    final isBob = userData.address == 1;
    MeshLogger().log("🤝 [${isBob ? 'BOB' : 'Alice'}] HS COMPLETE with $s");
  }

  @override
  Future<void> sendMessage(String dest, String text) async {
    final destPtr = dest.toNativeUtf8();
    final textPtr = text.toNativeUtf8();
    MeshLogger().log("📤 Message to $dest: $text");
    _ffi.sendMessage(_handle, destPtr, textPtr);
    malloc.free(destPtr);
    malloc.free(textPtr);

    _messageController.add(MessageModel.fromFfi(myName, dest, text, true));
  }

  @override
  Future<void> sendHandshake(String dest) async {
    final destPtr = dest.toNativeUtf8();
    MeshLogger().log("🤝 Handshake to $dest");
    _ffi.sendHandshake(_handle, destPtr);
    malloc.free(destPtr);
  }

  @override
  Future<void> processPacket(List<int> bytes) async {
    MeshLogger().log("📥 Processing incoming packet (${bytes.length} bytes)");
    final ptr = malloc<Uint8>(bytes.length);
    ptr.asTypedList(bytes.length).setAll(0, bytes);
    _ffi.processPacket(_handle, ptr, bytes.length);
    malloc.free(ptr);
  }

  @override
  Future<String> getMyIdentity() async =>
      _ffi.getPublicKeyHex(_handle).toDartString();

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
