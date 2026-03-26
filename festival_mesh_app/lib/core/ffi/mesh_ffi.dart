import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef MeshHandle = Pointer<Void>;

typedef OnSendCallback = Void Function(Pointer<Uint8> data, Int32 len, Pointer<Void> userData);
typedef OnMessageCallback = Void Function(Pointer<Utf8> sender, Pointer<Utf8> text, Pointer<Void> userData);
typedef OnHandshakeCallback = Void Function(Pointer<Utf8> sender, Pointer<Void> userData);

typedef NativeMeshCreate = MeshHandle Function(Pointer<Utf8> nodeName);
typedef NativeMeshDestroy = Void Function(MeshHandle h);
typedef NativeMeshProcessPacket = Void Function(MeshHandle h, Pointer<Uint8> data, Int32 len);
typedef NativeMeshSendHandshake = Void Function(MeshHandle h, Pointer<Utf8> dest);
typedef NativeMeshSendMessage = Void Function(MeshHandle h, Pointer<Utf8> dest, Pointer<Utf8> text);
typedef NativeMeshSetOnSend = Void Function(MeshHandle h, Pointer<NativeFunction<OnSendCallback>> cb, Pointer<Void> userData);
typedef NativeMeshSetOnMessage = Void Function(MeshHandle h, Pointer<NativeFunction<OnMessageCallback>> cb, Pointer<Void> userData);
typedef NativeMeshSetOnHandshake = Void Function(MeshHandle h, Pointer<NativeFunction<OnHandshakeCallback>> cb, Pointer<Void> userData);
typedef NativeMeshGetPublicKeyHex = Pointer<Utf8> Function(MeshHandle h);
typedef NativeMeshGetSafetyNumber = Pointer<Utf8> Function(MeshHandle h, Pointer<Utf8> peer);

typedef MeshCreate = MeshHandle Function(Pointer<Utf8> nodeName);
typedef MeshDestroy = void Function(MeshHandle h);
typedef MeshProcessPacket = void Function(MeshHandle h, Pointer<Uint8> data, int len);
typedef MeshSendHandshake = void Function(MeshHandle h, Pointer<Utf8> dest);
typedef MeshSendMessage = void Function(MeshHandle h, Pointer<Utf8> dest, Pointer<Utf8> text);
typedef MeshSetOnSend = void Function(MeshHandle h, Pointer<NativeFunction<OnSendCallback>> cb, Pointer<Void> userData);
typedef MeshSetOnMessage = void Function(MeshHandle h, Pointer<NativeFunction<OnMessageCallback>> cb, Pointer<Void> userData);
typedef MeshSetOnHandshake = void Function(MeshHandle h, Pointer<NativeFunction<OnHandshakeCallback>> cb, Pointer<Void> userData);
typedef MeshGetPublicKeyHex = Pointer<Utf8> Function(MeshHandle h);
typedef MeshGetSafetyNumber = Pointer<Utf8> Function(MeshHandle h, Pointer<Utf8> peer);

class MeshFFI {
  late DynamicLibrary _lib;

  late MeshCreate create;
  late MeshDestroy destroy;
  late MeshProcessPacket processPacket;
  late MeshSendHandshake sendHandshake;
  late MeshSendMessage sendMessage;
  late MeshSetOnSend setOnSend;
  late MeshSetOnMessage setOnMessage;
  late MeshSetOnHandshake setOnHandshake;
  late MeshGetPublicKeyHex getPublicKeyHex;
  late MeshGetSafetyNumber getSafetyNumber;

  MeshFFI({String? libraryPath}) {
    _lib = _loadLibrary(libraryPath);

    create = _lib.lookupFunction<NativeMeshCreate, MeshCreate>('mesh_create');
    destroy = _lib.lookupFunction<NativeMeshDestroy, MeshDestroy>('mesh_destroy');
    processPacket = _lib.lookupFunction<NativeMeshProcessPacket, MeshProcessPacket>('mesh_process_packet');
    sendHandshake = _lib.lookupFunction<NativeMeshSendHandshake, MeshSendHandshake>('mesh_send_handshake');
    sendMessage = _lib.lookupFunction<NativeMeshSendMessage, MeshSendMessage>('mesh_send_message');
    setOnSend = _lib.lookupFunction<NativeMeshSetOnSend, MeshSetOnSend>('mesh_set_on_send');
    setOnMessage = _lib.lookupFunction<NativeMeshSetOnMessage, MeshSetOnMessage>('mesh_set_on_message');
    setOnHandshake = _lib.lookupFunction<NativeMeshSetOnHandshake, MeshSetOnHandshake>('mesh_set_on_handshake');
    getPublicKeyHex = _lib.lookupFunction<NativeMeshGetPublicKeyHex, MeshGetPublicKeyHex>('mesh_get_public_key_hex');
    getSafetyNumber = _lib.lookupFunction<NativeMeshGetSafetyNumber, MeshGetSafetyNumber>('mesh_get_safety_number');
  }

  DynamicLibrary _loadLibrary(String? path) {
    if (path != null) return DynamicLibrary.open(path);
    if (Platform.isAndroid) return DynamicLibrary.open('libfestivalmesh.so');
    if (Platform.isIOS) return DynamicLibrary.process();
    if (Platform.isLinux) return DynamicLibrary.open('libfestivalmesh.so');
    if (Platform.isMacOS) return DynamicLibrary.open('libfestivalmesh.dylib');
    throw UnsupportedError('Platform not supported');
  }
}
