import 'dart:convert';
import 'package:depot/Not%20Signed/signin.dart';
import 'package:depot/Signed/home.dart';
import 'package:depot/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Splash extends StatefulWidget {
  const Splash({
    super.key,
  });

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool login = false;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? logged = pref.getBool('logged');
    if (logged != null) {
      if (logged) {
        String? id = pref.getString('id');
        String? password = pref.getString('password');
        try {
          final response = await http.post(
            Uri.parse(
              '${api}depotCheckLogin',
            ),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(
              {
                'id': id,
                'password': password,
              },
            ),
          );
          Map data = json.decode(response.body);
          login = data['status'];
        } catch (e) {
          login = false;
          showError("Can't Connect To Network !");
        }
      } else {
        login = false;
      }
    } else {
      login = false;
    }
    Future.delayed(
      const Duration(
        seconds: 2,
      ),
      redirect,
    );
  }

  void redirect() {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return login ? const Home() : const SignIn();
        },
      ),
    );
  }

  void showError(String error) {
    if (mounted) {
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
