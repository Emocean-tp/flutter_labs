class AquariumApiData {
  const AquariumApiData({
    required this.temperature,
    required this.phLevel,
    required this.lightLevel,
    required this.feedingTime,
  });

  final String temperature;
  final String phLevel;
  final String lightLevel;
  final String feedingTime;

  factory AquariumApiData.fromJson(Map<String, dynamic> json) {
    return AquariumApiData(
      temperature: json['temperature'].toString(),
      phLevel: json['phLevel'].toString(),
      lightLevel: json['lightLevel'].toString(),
      feedingTime: json['feedingTime'].toString(),
    );
  }

  Map<String, String> toMap() {
    return {
      'temperature': temperature,
      'phLevel': phLevel,
      'lightLevel': lightLevel,
      'feedingTime': feedingTime,
    };
  }
}