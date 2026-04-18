import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class MqttService {
  static final MqttServerClient _client = MqttServerClient.withPort(
    'wss://broker.hivemq.com',
    'flutter_nsbm_${DateTime.now().millisecondsSinceEpoch}',
    8884,
  );

  static DatabaseReference get _ref => FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://nsbm-smart-faculty-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref('tracking');

  static bool _isConnected = false;

  static Future<void> initialize() async {
    _client.port = 8884;
    _client.keepAlivePeriod = 20;
    _client.setProtocolV311();
    _client.logging(on: true);
    _client.connectTimeoutPeriod = 5000;
    _client.useWebSocket = true;
    _client.websocketProtocols = MqttClientConstants.protocolsSingleDefault;
    _client.onDisconnected = _onDisconnected;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(
          'flutter_nsbm_${DateTime.now().millisecondsSinceEpoch}',
        )
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    _client.connectionMessage = connMessage;

    try {
      print('[MQTT] Attempting connection to broker.hivemq.com:8884...');
      await _client.connect();
      _isConnected = true;
      print('[MQTT] ✅ Connected to broker');

      _client.subscribe('nsbm/tracking/zone', MqttQos.atLeastOnce);
      print('[MQTT] ✅ Subscribed to nsbm/tracking/zone');

      _client.updates!.listen((
        List<MqttReceivedMessage<MqttMessage>> messages,
      ) {
        final message = messages[0].payload as MqttPublishMessage;
        final payload = MqttPublishPayload.bytesToStringAsString(
          message.payload.message,
        );
        print('[MQTT] 📨 Received: $payload');
        _updateFirebase(payload.trim());
      });
    } catch (e) {
      print('[MQTT] ❌ Connection failed: $e');
      print('[MQTT] Client state: ${_client.connectionStatus}');
      _isConnected = false;
    }
  }

  static Future<void> _updateFirebase(String zoneId) async {
    try {
      await _ref.update({
        'current_zone': zoneId,
        'timestamp': ServerValue.timestamp,
      });
      print('[Firebase] ✅ Updated current_zone to $zoneId');
    } catch (e) {
      print('[Firebase] ❌ Update failed: $e');
    }
  }

  static void _onDisconnected() {
    _isConnected = false;
    print('[MQTT] Disconnected');
  }

  static bool get isConnected => _isConnected;
}
