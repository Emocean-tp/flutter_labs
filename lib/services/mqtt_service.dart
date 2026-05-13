import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_browser_client.dart';
import 'package:mqtt_client/mqtt_client.dart';

class MqttService {
  MqttService()
      : client = MqttBrowserClient(
          'ws://broker.hivemq.com/mqtt',
          'smart_aquarium_${DateTime.now().millisecondsSinceEpoch}',
        );

  final MqttBrowserClient client;

  final StreamController<String> temperatureController =
      StreamController<String>.broadcast();

  Stream<String> get temperatureStream => temperatureController.stream;

  Future<void> connect() async {
    client.port = 8000;
    client.setProtocolV311();
    client.keepAlivePeriod = 20;
    client.logging(on: false);

    final MqttConnectMessage connectionMessage = MqttConnectMessage()
        .withClientIdentifier(client.clientIdentifier)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    client.connectionMessage = connectionMessage;

    try {
      debugPrint('MQTT: connecting through WebSocket...');
      await client.connect();

      if (client.connectionStatus?.state == MqttConnectionState.connected) {
        debugPrint('MQTT: connected');
        subscribeToTopic('smart_aquarium/temperature');
      } else {
        debugPrint('MQTT: connection failed');
        client.disconnect();
      }
    } catch (error) {
      debugPrint('MQTT error: $error');
      client.disconnect();
    }
  }

  void subscribeToTopic(String topic) {
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final MqttPublishMessage receivedMessage =
          messages.first.payload as MqttPublishMessage;

      final String payload = MqttPublishPayload.bytesToStringAsString(
        receivedMessage.payload.message,
      );

      debugPrint('MQTT received: $payload');
      temperatureController.add(payload);
    });
  }

  void disconnect() {
    client.disconnect();
    temperatureController.close();
  }
}