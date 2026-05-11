import 'package:flutter/material.dart';
import 'package:iot_flutter_lab1/screens/home_screen.dart';
import 'package:iot_flutter_lab1/screens/register_screen.dart';
import 'package:iot_flutter_lab1/widgets/custom_button.dart';
import 'package:iot_flutter_lab1/widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Aquarium Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.water,
              size: 100,
              color: Colors.blue,
            ),

            const SizedBox(height: 20),

            const CustomTextField(
              label: 'Email',
              icon: Icons.email,
            ),

            const SizedBox(height: 20),

            const CustomTextField(
              label: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),

            const SizedBox(height: 20),

            CustomButton(
              text: 'Login',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 10),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
              child: const Text('Create account'),
            ),
          ],
        ),
      ),
    );
  }
}