import 'package:flutter/material.dart';
import 'package:iot_flutter_lab1/widgets/custom_button.dart';
import 'package:iot_flutter_lab1/widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Aquarium Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person_add,
              size: 100,
              color: Colors.cyan,
            ),

            const SizedBox(height: 20),

            const CustomTextField(
              label: 'Username',
              icon: Icons.person,
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
              text: 'Register',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}