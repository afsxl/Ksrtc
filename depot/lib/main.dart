import 'package:depot/Splash/splash.dart';
import 'package:flutter/material.dart';

String api = 'https://80401wwv-8000.inc1.devtunnels.ms/';

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
