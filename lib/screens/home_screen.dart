import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:iot_flutter_lab1/models/aquarium_api_data.dart';
import 'package:iot_flutter_lab1/repositories/aquarium_repository.dart';
import 'package:iot_flutter_lab1/screens/profile_screen.dart';
import 'package:iot_flutter_lab1/services/mqtt_service.dart';
import 'package:iot_flutter_lab1/services/network_service.dart';
import 'package:iot_flutter_lab1/services/storage_service.dart';
import 'package:iot_flutter_lab1/widgets/custom_button.dart';
import 'package:iot_flutter_lab1/widgets/custom_textfield.dart';
import 'package:iot_flutter_lab1/widgets/sensor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController phController = TextEditingController();
  final TextEditingController lightController = TextEditingController();
  final TextEditingController feedingController = TextEditingController();

  final MqttService mqttService = MqttService();

  StreamSubscription<String>? mqttSubscription;
  StreamSubscription<List<ConnectivityResult>>? connectivitySubscription;

  late Future<AquariumApiData> apiAquariumDataFuture;

  String temperature = '24°C - Normal';
  String mqttTemperature = 'Waiting for MQTT data...';
  String phLevel = '7.2 - Safe';
  String lightLevel = '65% - Day Mode';
  String feedingTime = 'Next feeding: 18:00';

  @override
  void initState() {
    super.initState();
    apiAquariumDataFuture = AquariumRepository.getAquariumData();
    loadAquariumData();
    checkInitialConnection();
    connectToMqtt();
    listenToConnectionChanges();
  }

  Future<void> loadAquariumData() async {
    final String? savedTemperature = await StorageService.getTemperature();
    final String? savedPhLevel = await StorageService.getPhLevel();
    final String? savedLightLevel = await StorageService.getLightLevel();
    final String? savedFeedingTime = await StorageService.getFeedingTime();

    setState(() {
      temperature = savedTemperature ?? temperature;
      phLevel = savedPhLevel ?? phLevel;
      lightLevel = savedLightLevel ?? lightLevel;
      feedingTime = savedFeedingTime ?? feedingTime;
    });
  }

  Future<void> checkInitialConnection() async {
    final bool hasInternet = await NetworkService.hasInternetConnection();

    if (!hasInternet && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showMessage('No internet connection. Offline mode enabled.');
      });
    }
  }

  Future<void> connectToMqtt() async {
    try {
      await mqttService.connect();

      mqttSubscription = mqttService.temperatureStream.listen(
        (String value) {
          setState(() {
            mqttTemperature = '$value°C from MQTT';
          });
        },
      );
    } catch (_) {
      setState(() {
        mqttTemperature = '25°C demo MQTT data';
      });
    }
  }

  void listenToConnectionChanges() {
    connectivitySubscription = NetworkService.connectionStream().listen(
      (List<ConnectivityResult> result) {
        if (result.contains(ConnectivityResult.none)) {
          showMessage('Internet connection lost');
        } else {
          showMessage('Internet connection restored');
        }
      },
    );
  }

  Future<void> saveData() async {
    final String newTemperature = temperatureController.text.trim();
    final String newPhLevel = phController.text.trim();
    final String newLightLevel = lightController.text.trim();
    final String newFeedingTime = feedingController.text.trim();

    if (newTemperature.isEmpty ||
        newPhLevel.isEmpty ||
        newLightLevel.isEmpty ||
        newFeedingTime.isEmpty) {
      showMessage('All aquarium fields are required');
      return;
    }

    await StorageService.saveAquariumData(
      temperature: newTemperature,
      phLevel: newPhLevel,
      lightLevel: newLightLevel,
      feedingTime: newFeedingTime,
    );

    setState(() {
      temperature = newTemperature;
      phLevel = newPhLevel;
      lightLevel = newLightLevel;
      feedingTime = newFeedingTime;
    });

    showMessage('Aquarium data saved locally');
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  void dispose() {
    temperatureController.dispose();
    phController.dispose();
    lightController.dispose();
    feedingController.dispose();
    mqttSubscription?.cancel();
    connectivitySubscription?.cancel();
    mqttService.disconnect();
    super.dispose();
  }

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
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const ProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Smart Aquarium Monitor',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<AquariumApiData>(
              future: apiAquariumDataFuture,
              builder: (
                BuildContext context,
                AsyncSnapshot<AquariumApiData> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const SensorCard(
                    title: 'API Aquarium Data',
                    value: 'Failed to load API data',
                    icon: Icons.error,
                  );
                }

                final AquariumApiData data = snapshot.data!;

                return Column(
                  children: [
                    SensorCard(
                      title: 'API Temperature',
                      value: '${data.temperature}°C',
                      icon: Icons.api,
                    ),
                    SensorCard(
                      title: 'API pH Level',
                      value: data.phLevel,
                      icon: Icons.science,
                    ),
                    SensorCard(
                      title: 'API Light Level',
                      value: data.lightLevel,
                      icon: Icons.light_mode,
                    ),
                    SensorCard(
                      title: 'API Feeding Time',
                      value: data.feedingTime,
                      icon: Icons.restaurant,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            SensorCard(
              title: 'MQTT Water Temperature',
              value: mqttTemperature,
              icon: Icons.cloud_sync,
            ),
            SensorCard(
              title: 'Local Water Temperature',
              value: temperature,
              icon: Icons.thermostat,
            ),
            SensorCard(
              title: 'pH Level',
              value: phLevel,
              icon: Icons.science,
            ),
            SensorCard(
              title: 'Light Level',
              value: lightLevel,
              icon: Icons.light_mode,
            ),
            SensorCard(
              title: 'Fish Feeder',
              value: feedingTime,
              icon: Icons.restaurant,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: temperatureController,
              label: 'New temperature',
              icon: Icons.thermostat,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: phController,
              label: 'New pH level',
              icon: Icons.science,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: lightController,
              label: 'New light level',
              icon: Icons.light_mode,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: feedingController,
              label: 'New feeding time',
              icon: Icons.restaurant,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Save aquarium data',
              onPressed: saveData,
            ),
          ],
        ),
      ),
    );
  }
}