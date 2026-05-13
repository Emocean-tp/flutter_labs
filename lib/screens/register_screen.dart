import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab1/cubits/auth_cubit.dart';
import 'package:iot_flutter_lab1/widgets/custom_button.dart';
import 'package:iot_flutter_lab1/widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocListener<AuthCubit, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state.message != null) {
          showMessage(context, state.message!);

          if (state.message == 'Registration successful') {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
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
                onPressed: () {
                  context.read<AuthCubit>().register(
                        username: usernameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
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