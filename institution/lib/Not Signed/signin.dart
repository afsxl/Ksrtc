import 'package:flutter/material.dart';
import 'package:institution/Signed/home.dart';
import 'package:institution/main.dart';
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
  List<String> places = [
    "Place Of Institution",
  ];
  List<String> institutions = [
    "Select Institution",
  ];
  String district = '';
  String place = '';
  String institution = '';
  bool loading = false;
  TextEditingController tPassword = TextEditingController();
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();
    district = districts[0];
    place = places[0];
    institution = institutions[0];
    loading = false;
    tPassword.text = '';
    hidePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                                    places = [
                                      "Place Of Institution",
                                    ];
                                    place = places[0];
                                    institutions = [
                                      "Select Institution",
                                    ];
                                    institution = institutions[0];
                                    getPlaces();
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
                          value: place,
                          isExpanded: true,
                          underline: const SizedBox(),
                          iconEnabledColor: Colors.black,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          dropdownColor: Colors.grey.shade300,
                          items: places.map(
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
                            if (value != places[0]) {
                              if (mounted) {
                                setState(
                                  () {
                                    place = value!;
                                    institutions = [
                                      "Select Institution",
                                    ];
                                    institution = institutions[0];
                                    getInstitutions();
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
                          value: institution,
                          isExpanded: true,
                          underline: const SizedBox(),
                          iconEnabledColor: Colors.black,
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          dropdownColor: Colors.grey.shade300,
                          items: institutions.map(
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
                            if (value != institutions[0]) {
                              if (mounted) {
                                setState(
                                  () {
                                    institution = value!;
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

  void getPlaces() async {
    try {
      final response = await http.post(
        Uri.parse(
          '${api}institutionGetPlaces',
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
      List list = data['places'];
      if (mounted) {
        setState(
          () {
            places = places + list.cast<String>();
          },
        );
      }
    } catch (e) {
      showError("Can't Connect To Network !");
    }
  }

  void getInstitutions() async {
    try {
      final response = await http.post(
        Uri.parse(
          '${api}institutionGetInstitutions',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'district': district,
            'place': place,
          },
        ),
      );
      Map data = json.decode(response.body);
      List list = data['institutions'];
      if (mounted) {
        setState(
          () {
            institutions = institutions + list.cast<String>();
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
      showError("Select District Of Your Institution !");
    } else if (place == places[0]) {
      showError("Select Place Of Your Institution !");
    } else if (institution == institutions[0]) {
      showError("Select Your Institution !");
    } else if (tPassword.text == '') {
      showError("Enter Password !");
    } else {
      try {
        final response = await http.post(
          Uri.parse(
            '${api}institutionSignin',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'district': district,
              'place': place,
              'institution': institution,
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
