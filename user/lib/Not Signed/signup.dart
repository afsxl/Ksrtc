import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Not%20Signed/signin.dart';
import 'package:user/Signed/home.dart';
import 'package:user/main.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    super.key,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController tName = TextEditingController();
  TextEditingController tUsername = TextEditingController();
  TextEditingController tEmail = TextEditingController();
  TextEditingController tPassword = TextEditingController();
  TextEditingController tConfirmPassword = TextEditingController();
  TextEditingController tOtp = TextEditingController();
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool hideOtp = true;
  bool editable = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    tName.text = '';
    tUsername.text = '';
    tEmail.text = '';
    tPassword.text = '';
    tConfirmPassword.text = '';
    tOtp.text = '';
    hidePassword = true;
    hideConfirmPassword = true;
    hideOtp = true;
    editable = true;
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
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
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 5,
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
                        'Sign Up',
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
                        controller: tName,
                        enabled: editable,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.black12,
                          label: const Text(
                            'Name',
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
                        controller: tUsername,
                        enabled: editable,
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
                        controller: tEmail,
                        enabled: editable,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.black12,
                          label: const Text(
                            'Email',
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
                        enabled: editable,
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
                              hidePassword ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: tConfirmPassword,
                        obscureText: hideConfirmPassword,
                        enabled: editable,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.black12,
                          label: const Text(
                            'Confirm Password',
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
                                    hideConfirmPassword = !hideConfirmPassword;
                                  },
                                );
                              }
                            },
                            child: Icon(
                              hideConfirmPassword ? Icons.visibility : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: hideOtp,
                        child: Container(
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
                            onPressed: checkData,
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: !hideOtp,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: tOtp,
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                counterText: '',
                                isDense: true,
                                filled: true,
                                fillColor: Colors.black12,
                                label: const Text(
                                  'Otp',
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
                            Row(
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
                                    onPressed: resendOtp,
                                    child: const Text(
                                      'Resend Otp',
                                      style: TextStyle(
                                        color: Colors.black,
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
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Don't Have An Account ?",
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
                      return const SignIn();
                    },
                  ),
                );
              },
              child: const Text(
                'SignIn',
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkData() async {
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
    } else if (tPassword.text == '') {
      showError('Enter Password !');
    } else if (tPassword.text.length < 8) {
      showError('Password Length Less Than 8 !');
    } else if (tConfirmPassword.text != tPassword.text) {
      showError("Password Doesn't Match !");
    } else {
      try {
        final response = await http.post(
          Uri.parse(
            '${api}userCheckUsername',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'username': tUsername.text,
              'email': tEmail.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status'] == 0) {
          if (mounted) {
            setState(
              () {
                hidePassword = true;
                hideConfirmPassword = true;
                hideOtp = false;
                editable = false;
              },
            );
          }
        } else if (data['status'] == 1) {
          showError("Username Already Exists !");
        } else if (data['status'] == 2) {
          showError("Email Already Exists !");
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
      showError("Enter Otp !");
    } else if (tOtp.text.length < 6) {
      showError("Incorrect Otp !");
    } else if (regex.hasMatch(tOtp.text) == false) {
      showError("Incorrect Otp !");
    } else {
      try {
        final response = await http.post(
          Uri.parse(
            '${api}userSignup',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'name': tName.text,
              'username': tUsername.text,
              'email': tEmail.text,
              'password': tPassword.text,
              'otp': tOtp.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status']) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool('logged', true);
          pref.setString('username', tUsername.text);
          pref.setString('password', tPassword.text);
          redirectHome();
        } else {
          showError("Incorrect Otp !");
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

  void resendOtp() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    try {
      final response = await http.post(
        Uri.parse(
          '${api}userSignupResend',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'username': tUsername.text,
            'email': tEmail.text,
          },
        ),
      );
      Map data = json.decode(response.body);
      if (data['status']) {
        showSuccess('Otp Resend');
      }
    } catch (e) {
      showError("Can't Connect To NetWork !");
    }
    if (mounted) {
      setState(
        () {
          loading = false;
        },
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
