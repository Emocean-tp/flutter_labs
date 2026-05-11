import 'package:flutter/material.dart';
import 'package:iot_flutter_lab1/screens/profile_screen.dart';
import 'package:iot_flutter_lab1/widgets/sensor_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aquarium Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Smart Aquarium Monitor',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            SensorCard(
              title: 'Water Temperature',
              value: '24°C - Normal',
              icon: Icons.thermostat,
            ),
            SensorCard(
              title: 'pH Level',
              value: '7.2 - Safe',
              icon: Icons.science,
            ),
            SensorCard(
              title: 'Light Level',
              value: '65% - Day Mode',
              icon: Icons.light_mode,
            ),
            SensorCard(
              title: 'Fish Feeder',
              value: 'Next feeding: 18:00',
              icon: Icons.restaurant,
            ),
          ],
        ),
      ),
    );
  }
}