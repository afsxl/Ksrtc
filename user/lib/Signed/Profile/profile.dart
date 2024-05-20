import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Not%20Signed/signin.dart';
import 'package:user/Signed/Profile/change_password.dart';
import 'package:user/main.dart';

class Profile extends StatefulWidget {
  const Profile({
    super.key,
  });

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController tName = TextEditingController();
  TextEditingController tUsername = TextEditingController();
  TextEditingController tEmail = TextEditingController();
  TextEditingController tOtp = TextEditingController();
  bool enabled = true;
  bool loading = false;
  bool otpVisible = false;

  @override
  void initState() {
    super.initState();
    loading = false;
    enabled = true;
    otpVisible = false;
    tOtp.text = '';
    getDetails();
  }

  void getDetails() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    tUsername.text = pref.getString('username').toString();
    try {
      final response = await http.post(
        Uri.parse(
          '${api}userGetProfile',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'username': tUsername.text,
          },
        ),
      );
      Map data = json.decode(response.body);
      tName.text = data['name'];
      tEmail.text = data['email'];
    } catch (e) {
      showError("Can't Connect To Network");
      if (mounted) {
        setState(
          () {
            Navigator.pop(context);
          },
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
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
        padding: const EdgeInsets.all(
          20,
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name',
                    ),
                    TextFormField(
                      controller: tName,
                      enabled: enabled,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        isDense: true,
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
                    const Text(
                      'Username',
                    ),
                    TextFormField(
                      controller: tUsername,
                      enabled: enabled,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        isDense: true,
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
                    const Text(
                      'Email',
                    ),
                    TextFormField(
                      controller: tEmail,
                      enabled: enabled,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        isDense: true,
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
                    Visibility(
                      visible: !otpVisible,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
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
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                'Change Password',
                              ),
                            ),
                          ),
                          Container(
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
                              onPressed: save,
                              child: const Text(
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                'Save',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: otpVisible,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 200,
                            child: TextFormField(
                              controller: tOtp,
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black12,
                                isDense: true,
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                label: const Text(
                                  'Otp',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
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
                              onPressed: submit,
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black26,
        ),
        child: TextButton(
          onPressed: logout,
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void save() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    RegExp specialCharactersName = RegExp(r'[!@#\$%^&*()-=+,_.?":{}|<>]');
    RegExp specialCharactersUsername = RegExp(r'[!@#\$%^ &*()-=+,.?":{}|<>]');
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (tName.text == '') {
      showError('Enter Name !');
    } else if (specialCharactersName.hasMatch(tName.text)) {
      showError('Enter A Valid Name !');
    } else if (tUsername.text == '') {
      showError('Enter Username !');
    } else if (specialCharactersUsername.hasMatch(tUsername.text)) {
      showError('Enter A Valid Username !');
    } else if (tEmail.text == '') {
      showError('Enter Email !');
    } else if (emailRegex.hasMatch(tEmail.text) == false) {
      showError('Enter A Valid Email !');
    } else {
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String? username = pref.getString('username');
        final response = await http.post(
          Uri.parse(
            '${api}userUpdateProfile',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              '_username': username,
              'name': tName.text,
              'username': tUsername.text,
              'email': tEmail.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status'] == 0) {
          showSuccess('Saved');
          pref.setString('username', tUsername.text);
        } else if (data['status'] == 1) {
          showError('User Already Exists !');
        } else if (data['status'] == 2) {
          showError('Email Already Exists !');
        } else if (data['status'] == -1) {
          if (mounted) {
            setState(
              () {
                enabled = false;
                otpVisible = true;
              },
            );
          }
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

  void submit() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    RegExp regex = RegExp(r'^[0-9]+$');
    if (tOtp.text == '') {
      showError('Enter Otp !');
    } else if (tOtp.text.length < 6) {
      showError("Incorrect Otp !");
    } else if (regex.hasMatch(tOtp.text) == false) {
      showError("Incorrect Otp !");
    } else {
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String? username = pref.getString('username');
        final response = await http.post(
          Uri.parse(
            '${api}userUpdateProfileOtp',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              '_username': username,
              'name': tName.text,
              'username': tUsername.text,
              'email': tEmail.text,
              'otp': tOtp.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status']) {
          showSuccess('Saved');
          pref.setString('username', tUsername.text);
          if (mounted) {
            setState(
              () {
                enabled = true;
                otpVisible = false;
                tOtp.text = '';
                getDetails();
              },
            );
          }
        } else {
          showError('Incorrect Otp !');
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

  void changePassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const ChangePassword();
        },
      ),
    );
  }

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('logged', false);
    pref.setString('username', '');
    pref.setString('password', '');
    if (mounted) {
      setState(
        () {
          Navigator.popUntil(
            context,
            (route) => false,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return const SignIn();
              },
            ),
          );
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
          margin: const EdgeInsets.all(
            20,
          ),
          behavior: SnackBarBehavior.floating,
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
          margin: const EdgeInsets.all(
            20,
          ),
          behavior: SnackBarBehavior.floating,
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
