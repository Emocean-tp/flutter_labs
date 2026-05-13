import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab1/cubits/auth_cubit.dart';
import 'package:iot_flutter_lab1/screens/register_screen.dart';
import 'package:iot_flutter_lab1/services/network_service.dart';
import 'package:iot_flutter_lab1/widgets/custom_button.dart';
import 'package:iot_flutter_lab1/widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> loginUser({
    required BuildContext context,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  }) async {
    final AuthCubit authCubit = context.read<AuthCubit>();
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    final bool hasInternet = await NetworkService.hasInternetConnection();

    if (!hasInternet) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('No internet connection'),
        ),
      );
      return;
    }

    await authCubit.login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
  }

  void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return BlocListener<AuthCubit, AuthState>(
      listener: (BuildContext context, AuthState state) {
        if (state.message != null) {
          showMessage(context, state.message!);
        }
      },
      child: Scaffold(
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
                onPressed: () {
                  loginUser(
                    context: context,
                    emailController: emailController,
                    passwordController: passwordController,
                  );
                },
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
      ),
    );
  }
}