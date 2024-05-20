import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ksrtc/main.dart';

class AddInstitution extends StatefulWidget {
  const AddInstitution({
    super.key,
  });

  @override
  State<AddInstitution> createState() => _AddInstitutionState();
}

class _AddInstitutionState extends State<AddInstitution> {
  TextEditingController tInstitution = TextEditingController();
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
  String district = '';
  String place = '';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    district = districts[0];
    place = places[0];
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Add Institution",
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
                        controller: tInstitution,
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
                            'Institution Name',
                            style: TextStyle(
                              color: Colors.black,
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
                          onPressed: addInstitution,
                          child: const Text(
                            "Apply",
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
          '${api}ksrtcGetPlaces',
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
    } else if (place == places[0]) {
      showError("Select A Place !");
    } else if (tInstitution.text == '') {
      showError("Enter Institution Name !");
    } else {
      try {
        final response = await http.post(
          Uri.parse(
            '${api}ksrtcAddInstitution',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'district': district,
              'place': place,
              'institution': tInstitution.text,
            },
          ),
        );
        Map data = json.decode(response.body);
        if (data['status']) {
          showSuccess("Institution Added");
          if (mounted) {
            setState(
              () {
                Navigator.pop(context);
              },
            );
          }
        } else {
          showError("Institution Already Exists !");
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
