import 'package:depot/Splash/splash.dart';
import 'package:flutter/material.dart';

String api = '';

void main() {
  runApp(
    const Depot(),
  );
}

class Depot extends StatelessWidget {
  const Depot({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Splash(),
    );
  }
}
