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
  void spawnMockPeer() {
    final namePtr = "MockBob".toNativeUtf8();
    _mockBobHandle = _ffi.create(namePtr);
    malloc.free(namePtr);
    sendHandshake("MockBob");
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
    _instance = this;
    final namePtr = myName.toNativeUtf8();
    _handle = _ffi.create(namePtr);
    malloc.free(namePtr);

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

    _setupCallbacks();
    _transport.start();
  }

  void _setupCallbacks() {
    _ffi.setOnMessage(_handle, _onMsgCallable.nativeFunction, nullptr);
    _ffi.setOnSend(_handle, _onSendCallable.nativeFunction, nullptr);
    _ffi.setOnHandshake(_handle, _onHsCallable.nativeFunction, nullptr);
  }

  static void _onMsgNative(
    Pointer<Utf8> sender,
    Pointer<Utf8> text,
    Pointer<Void> userData,
  ) {
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
    _instance?._transport.broadcast(bytes);
    MeshLogger().log("📡 Broadcating mesh packet (${len} bytes)");

    // LOOPBACK simulation:
    // If Alice sends something, we process it as Bob if Bob exists.
    if (_instance != null) {
      Future.delayed(const Duration(milliseconds: 50), () {
        final ptr = malloc<Uint8>(len);
        ptr.asTypedList(len).setAll(0, bytes);

        // Let Bob process what Alice sent
        if (_instance!._mockBobHandle != null) {
          _instance!._ffi.processPacket(_instance!._mockBobHandle!, ptr, len);
        }

        // Let Alice "receive" her own broadcast (standard loopback)
        _instance!.processPacket(bytes);

        malloc.free(ptr);
      });
    }
  }

  static void _onHsNative(Pointer<Utf8> sender, Pointer<Void> userData) {
    final s = sender.toDartString();
    MeshLogger().log("🤝 FFI HS COMPLETE: Session with $s");
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
