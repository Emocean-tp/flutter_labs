import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter_lab1/cubits/auth_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> confirmLogout(BuildContext context) async {
    final AuthCubit authCubit = context.read<AuthCubit>();
    final NavigatorState navigator = Navigator.of(context);

    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout ?? false) {
      await authCubit.logout();
      navigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (BuildContext context, AuthState state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Aquarium Profile'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => confirmLogout(context),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 120,
                  color: Colors.cyan,
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(state.username),
                  subtitle: const Text('Aquarium owner'),
                ),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: Text(state.email),
                  subtitle: const Text('Registered email'),
                ),
                const ListTile(
                  leading: Icon(Icons.water),
                  title: Text('Aquarium'),
                  subtitle: Text('Smart Aquarium #1'),
                ),
                const ListTile(
                  leading: Icon(Icons.wifi),
                  title: Text('Connection'),
                  subtitle: Text('Device online'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}