import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab1/cubits/aquarium_cubit.dart';
import 'package:iot_flutter_lab1/cubits/mqtt_cubit.dart';
import 'package:iot_flutter_lab1/models/aquarium_api_data.dart';
import 'package:iot_flutter_lab1/screens/profile_screen.dart';
import 'package:iot_flutter_lab1/widgets/custom_button.dart';
import 'package:iot_flutter_lab1/widgets/custom_textfield.dart';
import 'package:iot_flutter_lab1/widgets/sensor_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController temperatureController = TextEditingController();
    final TextEditingController phController = TextEditingController();
    final TextEditingController lightController = TextEditingController();
    final TextEditingController feedingController = TextEditingController();

    context.read<AquariumCubit>().loadData();
    context.read<MqttCubit>().connect();

    return BlocListener<AquariumCubit, AquariumState>(
      listener: (BuildContext context, AquariumState state) {
        if (state.message != null) {
          showMessage(context, state.message!);
        }
      },
      child: Scaffold(
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
              BlocBuilder<AquariumCubit, AquariumState>(
                builder: (BuildContext context, AquariumState state) {
                  if (state.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    );
                  }

                  final AquariumApiData? data = state.apiData;

                  if (data == null) {
                    return const SensorCard(
                      title: 'API Aquarium Data',
                      value: 'No API data',
                      icon: Icons.error,
                    );
                  }

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
              BlocBuilder<MqttCubit, MqttState>(
                builder: (BuildContext context, MqttState state) {
                  return SensorCard(
                    title: 'MQTT Water Temperature',
                    value: state.temperature,
                    icon: Icons.cloud_sync,
                  );
                },
              ),
              BlocBuilder<AquariumCubit, AquariumState>(
                builder: (BuildContext context, AquariumState state) {
                  return Column(
                    children: [
                      SensorCard(
                        title: 'Local Water Temperature',
                        value: state.temperature,
                        icon: Icons.thermostat,
                      ),
                      SensorCard(
                        title: 'pH Level',
                        value: state.phLevel,
                        icon: Icons.science,
                      ),
                      SensorCard(
                        title: 'Light Level',
                        value: state.lightLevel,
                        icon: Icons.light_mode,
                      ),
                      SensorCard(
                        title: 'Fish Feeder',
                        value: state.feedingTime,
                        icon: Icons.restaurant,
                      ),
                    ],
                  );
                },
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
                onPressed: () {
                  context.read<AquariumCubit>().saveData(
                        temperature: temperatureController.text.trim(),
                        phLevel: phController.text.trim(),
                        lightLevel: lightController.text.trim(),
                        feedingTime: feedingController.text.trim(),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}