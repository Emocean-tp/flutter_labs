import 'package:flutter/material.dart';
import 'package:iot_flutter_lab1/screens/home_screen.dart';
import 'package:iot_flutter_lab1/screens/login_screen.dart';
import 'package:iot_flutter_lab1/services/storage_service.dart';

void main() {
  runApp(const AquariumApp());
}

class AquariumApp extends StatelessWidget {
  const AquariumApp({super.key});

  Future<bool> isLoggedIn() async {
    return StorageService.isLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Aquarium Monitor',
      theme: ThemeData.dark(),
      home: FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.data ?? false) {
            return const HomeScreen();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}