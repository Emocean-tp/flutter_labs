import 'package:flutter/material.dart';
import 'package:iot_flutter_lab1/screens/home_screen.dart';
import 'package:iot_flutter_lab1/screens/register_screen.dart';
import 'package:iot_flutter_lab1/services/network_service.dart';
import 'package:iot_flutter_lab1/services/storage_service.dart';
import 'package:iot_flutter_lab1/widgets/custom_button.dart';
import 'package:iot_flutter_lab1/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final bool hasInternet = await NetworkService.hasInternetConnection();

    if (!hasInternet) {
      showMessage('No internet connection');
      return;
    }

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    final String? savedEmail = await StorageService.getEmail();
    final String? savedPassword = await StorageService.getPassword();

    if (email.isEmpty || password.isEmpty) {
      showMessage('Email and password are required');
      return;
    }

    if (email == savedEmail && password == savedPassword) {
      await StorageService.setLoggedIn(true);
      
      if (!mounted) {
        return;
      }

      await Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const HomeScreen(),
        ),
      );
      return;
    }

    showMessage('Invalid email or password');
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
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
            CustomTextField(
              controller: emailController,
              label: 'Email',
              icon: Icons.email,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Login',
              onPressed: loginUser,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const RegisterScreen(),
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