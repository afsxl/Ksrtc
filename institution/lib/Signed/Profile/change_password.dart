import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:institution/main.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController tPassword = TextEditingController();
  TextEditingController tNewPassword = TextEditingController();
  TextEditingController tConfirmNewPassword = TextEditingController();
  bool hidePassword = true;
  bool hideNewPassword = true;
  bool hideConfirmNewPassword = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    tPassword.text = '';
    tNewPassword.text = '';
    tConfirmNewPassword.text = '';
    hidePassword = true;
    hideNewPassword = true;
    hideConfirmNewPassword = true;
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black54,
        title: const Text(
          'Ksrtc Concession',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 75),
        child: Center(
          child: loading
              ? const CircularProgressIndicator(
                  color: Colors.black,
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: tPassword,
                        obscureText: hidePassword,
                        decoration: InputDecoration(
                          fillColor: Colors.black12,
                          filled: true,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          label: const Text(
                            'Current Password',
                            style: TextStyle(
                              color: Colors.black,
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
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: tNewPassword,
                        obscureText: hideNewPassword,
                        decoration: InputDecoration(
                          fillColor: Colors.black12,
                          filled: true,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          label: const Text(
                            'New Password',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(
                                  () {
                                    hideNewPassword = !hideNewPassword;
                                  },
                                );
                              }
                            },
                            child: Icon(
                              hideNewPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: tConfirmNewPassword,
                        obscureText: hideConfirmNewPassword,
                        decoration: InputDecoration(
                          fillColor: Colors.black12,
                          filled: true,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          label: const Text(
                            'Current Password',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(
                                  () {
                                    hideConfirmNewPassword =
                                        !hideConfirmNewPassword;
                                  },
                                );
                              }
                            },
                            child: Icon(
                              hideConfirmNewPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: TextButton(
                          onPressed: changePassword,
                          child: const Text(
                            'Change Password',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void changePassword() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    if (tPassword.text == '') {
      showError('Enter Current Password !');
    } else if (tNewPassword.text == '') {
      showError('Enter New Password !');
    } else if (tNewPassword.text.length < 8) {
      showError('Password Length Less Than 8 !');
    } else if (tNewPassword.text != tConfirmNewPassword.text) {
      showError("Passwords Does't Match !");
    } else {
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String? id = pref.getString('id');
        final response = await http.post(
          Uri.parse(
            '${api}institutionChangePassword',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'id': id,
              'password': tPassword.text,
              'newPassword': tNewPassword.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status']) {
          showSuccess("Password Changed");
          pref.setString('password', tNewPassword.text);
          if (mounted) {
            setState(
              () {
                Navigator.pop(context);
              },
            );
          }
        } else {
          showError('Incorrect Password !');
        }
      } catch (e) {
        showError("Can't Connect To Network !");
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

  void showSuccess(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(
            seconds: 1,
          ),
          backgroundColor: Colors.black,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(
            20,
          ),
          content: Text(
            msg,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
