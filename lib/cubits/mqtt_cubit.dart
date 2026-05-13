import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab1/services/mqtt_service.dart';

class MqttState {
  const MqttState({
    this.temperature = 'Waiting for MQTT data...',
  });

  final String temperature;
}

class MqttCubit extends Cubit<MqttState> {
  MqttCubit(this.mqttService) : super(const MqttState());

  final MqttService mqttService;
  StreamSubscription<String>? subscription;

  Future<void> connect() async {
    await mqttService.connect();

    subscription = mqttService.temperatureStream.listen((String value) {
      emit(MqttState(temperature: '$value°C from MQTT'));
    });
  }

  @override
  Future<void> close() {
    subscription?.cancel();
    mqttService.disconnect();
    return super.close();
  }
}