import 'package:iot_flutter_lab1/models/aquarium_api_data.dart';
import 'package:iot_flutter_lab1/services/aquarium_api_service.dart';
import 'package:iot_flutter_lab1/services/network_service.dart';
import 'package:iot_flutter_lab1/services/storage_service.dart';

class AquariumRepository {
  static Future<AquariumApiData> getAquariumData() async {
    final bool hasInternet = await NetworkService.hasInternetConnection();

    if (hasInternet) {
      final AquariumApiData apiData =
          await AquariumApiService.fetchAquariumData();

      await StorageService.saveApiAquariumData(
        temperature: apiData.temperature,
        phLevel: apiData.phLevel,
        lightLevel: apiData.lightLevel,
        feedingTime: apiData.feedingTime,
      );

      return apiData;
    }

    final Map<String, String> cachedData =
        await StorageService.getCachedApiAquariumData();

    return AquariumApiData(
      temperature: cachedData['temperature'] ?? 'No cached data',
      phLevel: cachedData['phLevel'] ?? 'No cached data',
      lightLevel: cachedData['lightLevel'] ?? 'No cached data',
      feedingTime: cachedData['feedingTime'] ?? 'No cached data',
    );
  }
}