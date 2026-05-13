import 'dart:async';

import 'package:iot_flutter_lab1/models/aquarium_api_data.dart';

class AquariumApiService {
  static Future<AquariumApiData> fetchAquariumData() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    return const AquariumApiData(
      temperature: '25',
      phLevel: '7.1',
      lightLevel: '70%',
      feedingTime: '20:00',
    );
  }
}