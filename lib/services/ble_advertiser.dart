import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';

class BleAdvertiser {
  // ESP32 nodes will scan for exactly this UUID
  // Don't change this — it must match what we put in the ESP32 code later
  static const String userUuid = 'a1b2c3d4-e5f6-7890-abcd-ef1234567890';

  static final FlutterBlePeripheral _peripheral = FlutterBlePeripheral();
  static bool _isAdvertising = false;
  static bool get isAdvertising => _isAdvertising;

  static Future<void> startAdvertising() async {
    try {
      final isSupported = await _peripheral.isSupported;
      if (!isSupported) {
        print('[BLE] Peripheral mode not supported on this device');
        return;
      }

      final advertiseData = AdvertiseData(
        serviceUuid: userUuid,
        includePowerLevel: true,
        includeDeviceName: false,
      );

      await _peripheral.start(advertiseData: advertiseData);
      _isAdvertising = true;
      print('[BLE] ✅ Now advertising UUID: $userUuid');
    } catch (e) {
      print('[BLE] ❌ Failed to start advertising: $e');
    }
  }

  static Future<void> stopAdvertising() async {
    try {
      await _peripheral.stop();
      _isAdvertising = false;
      print('[BLE] Stopped advertising');
    } catch (e) {
      print('[BLE] Failed to stop: $e');
    }
  }
}
