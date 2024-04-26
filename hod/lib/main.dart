import 'package:flutter/material.dart';
import 'package:hod/Splash/splash.dart';

String api = "";
void main() {
  runApp(const Hod());
}

class Hod extends StatelessWidget {
  const Hod({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Splash(),
    );
  }
}
