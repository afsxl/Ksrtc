import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:institution/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCourse extends StatefulWidget {
  const AddCourse({
    super.key,
  });

  @override
  State<AddCourse> createState() => _AddCourseState();
}

class _AddCourseState extends State<AddCourse> {
  TextEditingController tCourse = TextEditingController();
  TextEditingController tPassword = TextEditingController();
  TextEditingController tConfirmPassword = TextEditingController();
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    tCourse.text = '';
    tPassword.text = '';
    tConfirmPassword.text = '';
    loading = false;
    hidePassword = true;
    hideConfirmPassword = true;
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
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 6,
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
                        'Add Course / Class',
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
                        controller: tCourse,
                        decoration: InputDecoration(
                          isDense: true,
                          filled: true,
                          fillColor: Colors.black12,
                          label: const Text(
                            'Course Name',
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
                          onPressed: addCourse,
                          child: const Text(
                            'Add',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void addCourse() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    if (tCourse.text == '') {
      showError('Enter Course Name !');
    } else if (tPassword.text == '') {
      showError('Enter Password !');
    } else if (tPassword.text.length < 8) {
      showError('Password Length Less Than 8 !');
    } else if (tConfirmPassword.text != tPassword.text) {
      showError("Password Doesn't Match !");
    } else {
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String? id = pref.getString('id');
        final response = await http.post(
          Uri.parse(
            '${api}institutionAddCourse',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'id': id,
              'course': tCourse.text,
              'password': tPassword.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status']) {
          showSuccess("Course Added !");
          if (mounted) {
            setState(
              () {
                Navigator.pop(context);
              },
            );
          }
        } else {
          showError("Course Already Exists !");
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
