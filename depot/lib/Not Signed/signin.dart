import 'package:flutter/material.dart';
import 'package:depot/Signed/home.dart';
import 'package:depot/main.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SignIn extends StatefulWidget {
  const SignIn({
    super.key,
  });

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  List<String> districts = [
    "District Of Institution",
    "THIRUVANANTHAPURAM",
    "KOLLAM",
    "PATHANAMTHITTA",
    "ALAPPUZHA",
    "KOTTAYAM",
    "IDUKKI",
    "ERNAKULAM",
    "THRISSUR",
    "PALAKKAD",
    "MALAPPURAM",
    "KOZHIKODE",
    "WAYANAD",
    "KANNUR",
    "KASARAGOD",
  ];
  List<String> depots = [
    "Select Depot",
  ];
  String district = '';
  String depot = '';
  bool loading = false;
  TextEditingController tPassword = TextEditingController();
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    district = districts[0];
    depot = depots[0];
    loading = false;
    tPassword.text = '';
    hidePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: const Text(
          "Ksrtc Concession",
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
                        "Sign In",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: DropdownButton<String>(
                          value: district,
                          isExpanded: true,
                          underline: const SizedBox(),
                          iconEnabledColor: Colors.black,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          dropdownColor: Colors.grey.shade300,
                          items: districts.map(
                            (String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (String? value) async {
                            if (value != districts[0]) {
                              if (mounted) {
                                setState(
                                  () {
                                    district = value!;
                                    depots = [
                                      "Select Depot",
                                    ];
                                    depot = depots[0];
                                    getDepots();
                                  },
                                );
                              }
                            }
                          },
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: DropdownButton<String>(
                          value: depot,
                          isExpanded: true,
                          underline: const SizedBox(),
                          iconEnabledColor: Colors.black,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          dropdownColor: Colors.grey.shade300,
                          items: depots.map(
                            (String value) {
                              return DropdownMenuItem(
                                value: value,
                                child: Text(
                                  value,
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (String? value) {
                            if (value != depots[0]) {
                              if (mounted) {
                                setState(
                                  () {
                                    depot = value!;
                                  },
                                );
                              }
                            }
                          },
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
                          onPressed: signIn,
                          child: const Text(
                            "Sign In",
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

  void getDepots() async {
    try {
      final response = await http.post(
        Uri.parse(
          '${api}depotGetDepots',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'district': district,
          },
        ),
      );
      Map data = json.decode(response.body);
      List list = data['depots'];
      if (mounted) {
        setState(
          () {
            depots = depots + list.cast<String>();
          },
        );
      }
    } catch (e) {
      showError("Can't Connect To Network !");
    }
  }

  void signIn() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    if (district == districts[0]) {
      showError("Select District !");
    } else if (depot == depots[0]) {
      showError("Select Depot !");
    } else if (tPassword.text == '') {
      showError("Enter Password !");
    } else {
      try {
        final response = await http.post(
          Uri.parse(
            '${api}depotSignin',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'district': district,
              'depot': depot,
              'password': tPassword.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status']) {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool('logged', true);
          pref.setString('id', data['id'].toString());
          pref.setString('password', tPassword.text);
          if (mounted) {
            setState(
              () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) {
                      return const Home();
                    },
                  ),
                );
              },
            );
          }
        } else {
          showError("Incorrect Password !");
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
}
