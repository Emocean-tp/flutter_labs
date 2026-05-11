import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT Flutter Lab',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int counter = 0;

  TextEditingController controller = TextEditingController();

  void increaseCounter() {
    setState(() {
      if (controller.text == 'Avada Kedavra') {
        counter = 0;
      } else {
        counter++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IoT Flutter Lab 1'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Counter: $counter',
                style: const TextStyle(fontSize: 30),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter text',
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: increaseCounter,
                child: const Text('Press'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
