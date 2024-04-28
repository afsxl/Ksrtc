import 'package:flutter/material.dart';
import 'package:user/Splash/splash.dart';

String api = "";
void main() {
  runApp(
    const User(),
  );
}

class User extends StatelessWidget {
  const User({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Splash(),
    );
  }
}
