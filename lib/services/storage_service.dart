import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  static Future<String?> getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('username');
  }

  static Future<String?> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('email');
  }

  static Future<String?> getPassword() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('password');
  }

  static Future<void> saveAquariumData({
    required String temperature,
    required String phLevel,
    required String lightLevel,
    required String feedingTime,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('temperature', temperature);
    await prefs.setString('phLevel', phLevel);
    await prefs.setString('lightLevel', lightLevel);
    await prefs.setString('feedingTime', feedingTime);
  }

  static Future<String?> getTemperature() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('temperature');
  }

  static Future<String?> getPhLevel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('phLevel');
  }

  static Future<String?> getLightLevel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('lightLevel');
  }

  static Future<String?> getFeedingTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('feedingTime');
  }
}