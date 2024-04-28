import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ksrtc/main.dart';

class AddDepot extends StatefulWidget {
  const AddDepot({super.key});

  @override
  State<AddDepot> createState() => _AddDepotState();
}

class _AddDepotState extends State<AddDepot> {
  TextEditingController tDepot = TextEditingController();
  TextEditingController tPassword = TextEditingController();
  TextEditingController tConfirmPassword = TextEditingController();
  List<String> districts = [
    "District",
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
  String district = '';
  bool loading = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    district = districts[0];
    tPassword.text = '';
    tConfirmPassword.text = '';
    loading = false;
    hidePassword = true;
    hideConfirmPassword = true;
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Add Depot",
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
                        controller: tDepot,
                        keyboardType: TextInputType.name,
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
                            'Depot Name',
                            style: TextStyle(
                              color: Colors.black,
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
                              hideConfirmPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
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
                          onPressed: addInstitution,
                          child: const Text(
                            "Add Depot",
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

  void addInstitution() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    if (district == districts[0]) {
      showError("Select A District !");
    } else if (tDepot.text == '') {
      showError("Enter Depot Name !");
    } else if (tPassword.text == '') {
      showError("Enter Password !");
    } else if (tPassword.text.length < 8) {
      showError('Password Length Less Than 8 !');
    } else if (tConfirmPassword.text != tPassword.text) {
      showError("Password Doesn't Match !");
    } else {
      try {
        final response = await http.post(
          Uri.parse(
            '${api}ksrtcAddDepot',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'district': district,
              'depot': tDepot.text,
              'password': tPassword.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status']) {
          showSuccess("Depot Added");
          if (mounted) {
            setState(
              () {
                Navigator.pop(context);
              },
            );
          }
        } else {
          showError("Depot Already Exists !");
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
