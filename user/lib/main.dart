import 'package:flutter/material.dart';
import 'package:user/Splash/splash.dart';

String api = "https://80401wwv-8000.inc1.devtunnels.ms/";
void main() {
  runApp(
    const User(),
  );
}

class User extends StatelessWidget {
  const User({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Splash(),
    );
  }
}
