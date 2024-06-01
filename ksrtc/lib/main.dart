import 'package:flutter/material.dart';
import 'package:ksrtc/Signed/home.dart';

String api = "https://80401wwv-8000.inc1.devtunnels.ms/";
void main() {
  runApp(
    const Ksrtc(),
  );
}

class Ksrtc extends StatelessWidget {
  const Ksrtc({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}
