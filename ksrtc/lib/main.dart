import 'package:flutter/material.dart';
import 'package:ksrtc/Splash/splash.dart';

String api = "";
void main() {
  runApp(
    const Ksrtc(),
  );
}

class Ksrtc extends StatelessWidget {
  const Ksrtc({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Splash(),
    );
  }
}
