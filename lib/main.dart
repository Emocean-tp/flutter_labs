import 'package:flutter/material.dart';
import 'package:iot_flutter_lab1/screens/login_screen.dart';

void main() {
  runApp(const AquariumApp());
}

class AquariumApp extends StatelessWidget {
  const AquariumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Aquarium Monitor',
      theme: ThemeData.dark(),
      home: const LoginScreen(),
    );
  }
}