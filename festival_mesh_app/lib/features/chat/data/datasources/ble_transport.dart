import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:permission_handler/permission_handler.dart';

class BleTransport {
  static const int companyId = 0xFFFF; // Custom Festival Mesh ID
  final Function(List<int>) onDataReceived;

  StreamSubscription<List<ScanResult>>? _scanSubscription;
  final _peripheral = FlutterBlePeripheral();

  BleTransport({required this.onDataReceived});

  Future<bool> checkPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();
      return statuses.values.every((s) => s.isGranted);
    }
    return true; // iOS handles via Info.plist
  }

  Future<void> start() async {
    final granted = await checkPermissions();
    if (!granted) {
      debugPrint("❌ BLE Permissions not granted");
      return;
    }

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      for (ScanResult r in results) {
        final manufacturerData = r.advertisementData.manufacturerData;
        if (manufacturerData.containsKey(companyId)) {
          final data = manufacturerData[companyId]!;
          debugPrint("📡 [BLE MESH] Incoming: ${data.length} bytes from ${r.device.remoteId}");
          onDataReceived(data);
        }
      }
    });

    await FlutterBluePlus.startScan(
      androidScanMode: AndroidScanMode.lowLatency,
    );
  }

  Future<void> stop() async {
    await _scanSubscription?.cancel();
    await FlutterBluePlus.stopScan();
    await _peripheral.stop();
  }

  Future<void> broadcast(List<int> bytes) async {
    debugPrint("🔥 BLE BROADCAST: ${bytes.length} bytes");
    
    final advertiseData = AdvertiseData(
      manufacturerId: companyId,
      manufacturerData: Uint8List.fromList(bytes),
      includeDeviceName: false,
    );

    if (await _peripheral.isAdvertising) await _peripheral.stop();
    await _peripheral.start(advertiseData: advertiseData);
    
    Future.delayed(const Duration(milliseconds: 300), () async {
      await _peripheral.stop();
    });
  }
}
