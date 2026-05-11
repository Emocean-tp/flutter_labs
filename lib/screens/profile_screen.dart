import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aquarium Profile'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.account_circle,
              size: 120,
              color: Colors.cyan,
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('User'),
              subtitle: Text('Aquarium owner'),
            ),
            ListTile(
              leading: Icon(Icons.water),
              title: Text('Aquarium'),
              subtitle: Text('Smart Aquarium #1'),
            ),
            ListTile(
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