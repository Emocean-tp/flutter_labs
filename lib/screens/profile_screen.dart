import 'package:flutter/material.dart';
import 'package:iot_flutter_lab1/screens/login_screen.dart';
import 'package:iot_flutter_lab1/services/storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = 'Aquarium owner';
  String email = 'No email';

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final String? savedUsername = await StorageService.getUsername();
    final String? savedEmail = await StorageService.getEmail();

    setState(() {
      username = savedUsername ?? username;
      email = savedEmail ?? email;
    });
  }

  Future<void> confirmLogout() async {
    final bool? shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout ?? false) {
      await StorageService.clearUserSession();

      if (!mounted) {
        return;
      }

      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => const LoginScreen(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aquarium Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: confirmLogout,
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
              title: Text(username),
              subtitle: const Text('Aquarium owner'),
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(email),
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
  }
}