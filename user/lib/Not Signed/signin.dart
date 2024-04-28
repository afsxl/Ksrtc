import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Not%20Signed/forgot_password.dart';
import 'package:user/Not%20Signed/signup.dart';
import 'package:user/Signed/home.dart';
import 'package:user/main.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController tUsername = TextEditingController();
  TextEditingController tPassword = TextEditingController();
  bool hidePassword = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    tUsername.text = '';
    tPassword.text = '';
    hidePassword = true;
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text(
          'Ksrtc Concession',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 75,
        ),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  color: Colors.black,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: tUsername,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.black12,
                          label: const Text(
                            'Username',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: tPassword,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.black12,
                          label: const Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(
                                  () {
                                    hidePassword = !hidePassword;
                                  },
                                );
                              }
                            },
                            child: Icon(
                              hidePassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: TextButton(
                              onPressed: forgetPassword,
                              child: const Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              border: Border.all(
                                color: Colors.black,
                              ),
                            ),
                            child: TextButton(
                              onPressed: signIn,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black54,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Have An Account ?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) {
                      return const SignUp();
                    },
                  ),
                );
              },
              child: const Text(
                'SignUp',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void signIn() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (tUsername.text == '') {
      showError('Enter Username !');
    } else if (tPassword.text == '') {
      showError('Enter Password !');
    } else {
      pref.setString('username', tUsername.text);
      pref.setString('password', tPassword.text);
      try {
        final response = await http.post(
          Uri.parse(
            '${api}userCheckLogin',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'username': tUsername.text,
              'password': tPassword.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status']) {
          pref.setBool('logged', true);
          redirectHome();
        } else {
          showError('Incorrect Username Or Password !');
        }
      } catch (e) {
        showError("Can't Connect To NetWork !");
      }
    }
    if (mounted) {
      setState(
        () {
          loading = false;
        },
      );
    }
  }

  void showError(String error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(
            seconds: 1,
          ),
          backgroundColor: Colors.red.shade900,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(
            20,
          ),
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

  void redirectHome() {
    Navigator.pop(context);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const Home();
        },
      ),
    );
  }

  void forgetPassword() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const ForgetPassword();
        },
      ),
    );
  }
}
