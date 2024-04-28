import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hod/Not%20Signed/signin.dart';
import 'package:hod/Signed/home.dart';
import 'package:hod/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
        } else {
          showError("Can't Connect To NetWork !");
        }
      },
    ).catchError(
      (e) {
        showError("Can't Connect To NetWork !");
      },
    );
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool? logged = pref.getBool('logged');
    if (logged != null) {
      if (logged) {
        try {
          String? id = pref.getString('id');
          String? password = pref.getString('password');
          final response = await http.post(
            Uri.parse(
              '${api}hodCheckLogin',
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
          showError("Can't Connect To Network !");
          login = false;
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
