import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 1, 30, 56), // Change the background color here
      body: Center(
        child: Column(
          children: [
            Text('Hello World'),
            Text('Hello World'),
            Text('Hello World'),
          ],
        ),
      ),
    );
  }
}
