import 'package:flutter/material.dart';
import 'package:institution/Splash/splash.dart';

String api = "https://80401wwv-8000.inc1.devtunnels.ms/";
void main() {
  runApp(
    const Institution(),
  );
}

class Institution extends StatelessWidget {
  const Institution({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Splash(),
    );
  }
}
