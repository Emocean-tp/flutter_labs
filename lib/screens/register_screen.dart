import 'package:flutter/material.dart';
import 'package:iot_flutter_lab1/services/storage_service.dart';
import 'package:iot_flutter_lab1/widgets/custom_button.dart';
import 'package:iot_flutter_lab1/widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> registerUser() async {
    final String username = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (username.isEmpty) {
      showMessage('Username cannot be empty');
      return;
    }

    if (!email.contains('@')) {
      showMessage('Email must contain @');
      return;
    }

    if (password.length < 6) {
      showMessage('Password must be at least 6 characters');
      return;
    }

    await StorageService.saveUser(
      username: username,
      email: email,
      password: password,
    );

    showMessage('Registration successful');

    if (!mounted) {
      return;
    }

    Navigator.pop(context);
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
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
            CustomTextField(
              controller: usernameController,
              label: 'Username',
              icon: Icons.person,
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
              text: 'Register',
              onPressed: registerUser,
            ),
          ],
        ),
      ),
    );
  }
}