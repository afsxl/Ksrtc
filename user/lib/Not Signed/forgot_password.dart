import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:user/main.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  TextEditingController tId = TextEditingController();
  TextEditingController tOtp = TextEditingController();
  TextEditingController tPassword = TextEditingController();
  TextEditingController tConfirmPassword = TextEditingController();
  bool idVisible = true;
  bool otpVisible = false;
  bool passwordVisible = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  String username = '';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    tId.text = '';
    tOtp.text = '';
    tPassword.text = '';
    tConfirmPassword.text = '';
    idVisible = true;
    otpVisible = false;
    passwordVisible = false;
    hidePassword = true;
    hideConfirmPassword = true;
    username = '';
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
                        'Forgot Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Visibility(
                        visible: idVisible,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: tId,
                              enabled: !otpVisible,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black12,
                                isDense: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    10,
                                  ),
                                ),
                                label: const Text(
                                  'Username / Email',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Visibility(
                              visible: !otpVisible,
                              child: Container(
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
                                  onPressed: getOtp,
                                  child: const Text(
                                    'Get Otp',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: otpVisible,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: tOtp,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              decoration: InputDecoration(
                                filled: true,
                                counterText: '',
                                fillColor: Colors.black12,
                                isDense: true,
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
                          ],
                        ),
                      ),
                      Visibility(
                        visible: passwordVisible,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: tPassword,
                              obscureText: hidePassword,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black12,
                                isDense: true,
                                label: const Text(
                                  'New Password',
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
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.black12,
                                isDense: true,
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Future<void> getOtp() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    if (tId.text == '') {
      showError('Enter Username Or Email !');
    } else {
      try {
        final response = await http.post(
          Uri.parse(
            '${api}userForgotPassword',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'id': tId.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status']) {
          if (mounted) {
            setState(
              () {
                username = data['username'];
                otpVisible = true;
              },
            );
          }
        } else {
          showError('No Account Registered With ${tId.text} !');
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

  void resendOtp() async {
    await getOtp();
    showSuccess('Otp Resented');
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
            '${api}userOtpCheck',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'username': username,
              'otp': tOtp.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status']) {
          if (mounted) {
            setState(
              () {
                idVisible = false;
                otpVisible = false;
                passwordVisible = true;
              },
            );
          }
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

  void changePassword() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    if (tPassword.text == '') {
      showError('Enter Password !');
    } else if (tPassword.text.length < 8) {
      showError('Password Length Less Than 8 !');
    } else if (tConfirmPassword.text != tPassword.text) {
      showError("Password Doesn't Match !");
    } else {
      try {
        await http.post(
          Uri.parse(
            '${api}userForgotPasswordChange',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'username': username,
              'password': tPassword.text,
            },
          ),
        );
        showSuccess('Password Changed');
        if (mounted) {
          setState(
            () {
              Navigator.pop(context);
            },
          );
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(
          seconds: 1,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade900,
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

  void showSuccess(String msg) {
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
