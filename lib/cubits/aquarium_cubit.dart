import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab1/models/aquarium_api_data.dart';
import 'package:iot_flutter_lab1/repositories/aquarium_repository.dart';
import 'package:iot_flutter_lab1/services/storage_service.dart';

class AquariumState {
  const AquariumState({
    this.apiData,
    this.temperature = '24°C - Normal',
    this.phLevel = '7.2 - Safe',
    this.lightLevel = '65% - Day Mode',
    this.feedingTime = 'Next feeding: 18:00',
    this.isLoading = false,
    this.message,
  });

  final AquariumApiData? apiData;
  final String temperature;
  final String phLevel;
  final String lightLevel;
  final String feedingTime;
  final bool isLoading;
  final String? message;
}

class AquariumCubit extends Cubit<AquariumState> {
  AquariumCubit() : super(const AquariumState());

  Future<void> loadData() async {
    emit(AquariumState(isLoading: true));

    final AquariumApiData apiData =
        await AquariumRepository.getAquariumData();

    final String? temperature = await StorageService.getTemperature();
    final String? phLevel = await StorageService.getPhLevel();
    final String? lightLevel = await StorageService.getLightLevel();
    final String? feedingTime = await StorageService.getFeedingTime();

    emit(
      AquariumState(
        apiData: apiData,
        temperature: temperature ?? state.temperature,
        phLevel: phLevel ?? state.phLevel,
        lightLevel: lightLevel ?? state.lightLevel,
        feedingTime: feedingTime ?? state.feedingTime,
      ),
    );
  }

  Future<void> saveData({
    required String temperature,
    required String phLevel,
    required String lightLevel,
    required String feedingTime,
  }) async {
    if (temperature.isEmpty ||
        phLevel.isEmpty ||
        lightLevel.isEmpty ||
        feedingTime.isEmpty) {
      emit(
        AquariumState(
          apiData: state.apiData,
          temperature: state.temperature,
          phLevel: state.phLevel,
          lightLevel: state.lightLevel,
          feedingTime: state.feedingTime,
          message: 'All fields are required',
        ),
      );
      return;
    }

    await StorageService.saveAquariumData(
      temperature: temperature,
      phLevel: phLevel,
      lightLevel: lightLevel,
      feedingTime: feedingTime,
    );

    emit(
      AquariumState(
        apiData: state.apiData,
        temperature: temperature,
        phLevel: phLevel,
        lightLevel: lightLevel,
        feedingTime: feedingTime,
        message: 'Aquarium data saved',
      ),
    );
  }
}