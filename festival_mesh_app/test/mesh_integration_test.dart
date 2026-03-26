import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:festival_mesh_app/core/ffi/mesh_ffi.dart';

void main() {
  late MeshFFI ffi;
  final dylibPath = '${Directory.current.parent.path}/festival-mesh-core/build/libfestivalmesh.dylib';

  setUpAll(() {
    if (!File(dylibPath).existsSync()) {
      fail('Native library not found at $dylibPath. Please build it first.');
    }
    ffi = MeshFFI(libraryPath: dylibPath);
  });

  test('FFI: Should create and destroy Mesh Engine', () {
    final name = 'TestNode'.toNativeUtf8();
    final handle = ffi.create(name);
    expect(handle, isNot(nullptr));
    
    ffi.destroy(handle);
    malloc.free(name);
  });

  test('FFI: Should perform full handshake cycle', () async {
    final aliceName = 'Alice'.toNativeUtf8();
    final bobName = 'Bob'.toNativeUtf8();
    
    final hAlice = ffi.create(aliceName);
    final hBob = ffi.create(bobName);

    bool receivedByBob = false;

    // Connect Bob to Alice (mock transport)
    void onSendAlice(Pointer<Uint8> data, int len, Pointer<Void> userData) {
      final bytes = data.asTypedList(len);
      final bobBuffer = malloc<Uint8>(len);
      bobBuffer.asTypedList(len).setAll(0, bytes);
      
      ffi.processPacket(hBob, bobBuffer, len);
      malloc.free(bobBuffer);
    }

    void onHandshakeBob(Pointer<Utf8> peer, Pointer<Void> userData) {
      if (peer.toDartString() == 'Alice') {
        receivedByBob = true;
      }
    }

    // Register callbacks
    final nativeOnSend = NativeCallable<OnSendCallback>.isolateLocal(onSendAlice);
    final nativeOnHandshake = NativeCallable<OnHandshakeCallback>.isolateLocal(onHandshakeBob);

    ffi.setOnSend(hAlice, nativeOnSend.nativeFunction, nullptr);
    ffi.setOnHandshake(hBob, nativeOnHandshake.nativeFunction, nullptr);

    // Act
    final dest = 'Bob'.toNativeUtf8();
    ffi.sendHandshake(hAlice, dest);
    
    // Give time for callback (it should be immediate but let's be safe)
    await Future.delayed(const Duration(milliseconds: 100));

    expect(receivedByBob, isTrue);

    // Cleanup
    ffi.destroy(hAlice);
    ffi.destroy(hBob);
    malloc.free(aliceName);
    malloc.free(bobName);
    malloc.free(dest);
    nativeOnSend.close();
    nativeOnHandshake.close();
  });

  test('FFI: Should fragment and reassemble large messages', () async {
    final aliceName = 'Alice'.toNativeUtf8();
    final bobName = 'Bob'.toNativeUtf8();
    final hAlice = ffi.create(aliceName);
    final hBob = ffi.create(bobName);

    String receivedText = '';
    int packetsSent = 0;

    void onSend(Pointer<Uint8> data, int len, Pointer<Void> userData) {
      packetsSent++;
      final buf = malloc<Uint8>(len);
      buf.asTypedList(len).setAll(0, data.asTypedList(len));
      ffi.processPacket(hBob, buf, len);
      malloc.free(buf);
    }

    void onMessage(Pointer<Utf8> sender, Pointer<Utf8> text, Pointer<Void> userData) {
      if (sender.toDartString() == 'Alice') {
        receivedText = text.toDartString();
      }
    }

    final nSend = NativeCallable<OnSendCallback>.isolateLocal(onSend);
    final nMsg = NativeCallable<OnMessageCallback>.isolateLocal(onMessage);

    ffi.setOnSend(hAlice, nSend.nativeFunction, nullptr);
    ffi.setOnMessage(hBob, nMsg.nativeFunction, nullptr);

    // Verify identity retrieval works
    final bPk = ffi.getPublicKeyHex(hBob);
    final aPk = ffi.getPublicKeyHex(hAlice);
    expect(bPk, isNot(nullptr));
    expect(aPk, isNot(nullptr));
    
    // Send a large message (approx 1KB, CHUNK is around 180)
    final largeText = 'A' * 500; 
    final bName = 'Bob'.toNativeUtf8();
    final tText = largeText.toNativeUtf8();

    // Note: buildMessage in C++ core handles its own encryption if session exists.
    // In DUMMY_CRYPTO mode, it just pipes.
    ffi.sendMessage(hAlice, bName, tText);

    await Future.delayed(const Duration(milliseconds: 200));

    expect(receivedText, equals(largeText));
    expect(packetsSent, greaterThan(1)); // verified fragmentation happened

    ffi.destroy(hAlice);
    ffi.destroy(hBob);
    malloc.free(aliceName);
    malloc.free(bobName);
    malloc.free(bName);
    malloc.free(tText);
    nSend.close();
    nMsg.close();
  });
}
