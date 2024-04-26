import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ksrtc/Signed/home.dart';
import 'package:ksrtc/main.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    getApi();
  }

  void getApi() async {
    String url = 'https://raw.githubusercontent.com/afsxl/Api/main/Api.txt';
    await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/vnd.github.v3.raw',
      },
    ).then(
      (response) {
        if (response.statusCode == 200) {
          api = response.body;
          api = api.substring(0, api.length - 1);
        } else {
          showError("Can't Connect To NetWork !");
        }
      },
    ).catchError(
      (e) {
        showError("Can't Connect To NetWork !");
      },
    );
    redirect();
  }

  void redirect() {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const Home();
        },
      ),
    );
  }

  void showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(
          seconds: 1,
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(
          20,
        ),
        backgroundColor: Colors.red.shade900,
        content: Text(
          error,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/ksrtc.png',
              scale: 6,
            ),
            const Text(
              'Ksrtc Concession',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
