import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab1/cubits/aquarium_cubit.dart';
import 'package:iot_flutter_lab1/cubits/auth_cubit.dart';
import 'package:iot_flutter_lab1/cubits/mqtt_cubit.dart';
import 'package:iot_flutter_lab1/screens/home_screen.dart';
import 'package:iot_flutter_lab1/screens/login_screen.dart';
import 'package:iot_flutter_lab1/services/mqtt_service.dart';

void main() {
  runApp(const AquariumApp());
}

class AquariumApp extends StatelessWidget {
  const AquariumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit()..checkSession(),
        ),
        BlocProvider<AquariumCubit>(
          create: (BuildContext context) => AquariumCubit(),
        ),
        BlocProvider<MqttCubit>(
          create: (BuildContext context) => MqttCubit(MqttService()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Aquarium Monitor',
        theme: ThemeData.dark(),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (BuildContext context, AuthState state) {
            if (state.isLoggedIn) {
              return const HomeScreen();
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}