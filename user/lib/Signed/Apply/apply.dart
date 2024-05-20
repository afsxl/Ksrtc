import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/main.dart';

class ApplyConcession extends StatefulWidget {
  const ApplyConcession({
    super.key,
  });

  @override
  State<ApplyConcession> createState() => _ApplyConcessionState();
}

class _ApplyConcessionState extends State<ApplyConcession> {
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
  List<String> homeDistricts = [
    "District Of Depot",
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
    "Select Your Depot",
  ];
  List<String> places = [
    "Place Of Institution",
  ];
  List<String> institutions = [
    "Select Institution",
  ];
  List<String> courses = [
    "Select Course Or Class",
  ];
  String homeDistrict = '';
  String depot = '';
  String district = '';
  String place = '';
  String institution = '';
  String course = '';
  bool loading = false;
  TextEditingController tName = TextEditingController();
  TextEditingController tAadhar = TextEditingController();
  TextEditingController tAge = TextEditingController();
  TextEditingController tStartPoint = TextEditingController();
  TextEditingController tEndPoint = TextEditingController();
  TextEditingController tRate = TextEditingController();
  String photoName = "Select Your Photo";
  File? photo;
  String aadharFrontName = "Select Aadhar Front Side";
  File? aadharFront;
  String aadharBackName = "Select Aadhar Back Side";
  File? aadharBack;
  String idName = "Select Your Institution Id";
  File? id;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    homeDistrict = homeDistricts[0];
    depot = depots[0];
    district = districts[0];
    place = places[0];
    institution = institutions[0];
    course = courses[0];
    loading = false;
    tName.text = '';
    tAadhar.text = '';
    tAge.text = '';
    tStartPoint.text = '';
    tEndPoint.text = '';
    tRate.text = '';
    photoName = "Your Photo";
    aadharFrontName = "Aadhar Front Side";
    aadharBackName = "Aadhar Back Side";
    idName = "Your Institution Id";
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
          vertical: 15,
          horizontal: 10,
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Apply Concession',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: tName,
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
                          'Name',
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
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (mounted) {
                                setState(
                                  () {
                                    if (picked != null) {
                                      photo = File(picked.path);
                                      photoName = picked.name;
                                    }
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    photoName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (mounted) {
                                setState(
                                  () {
                                    if (picked != null) {
                                      id = File(picked.path);
                                      idName = picked.name;
                                    }
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    idName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: tAge,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            decoration: InputDecoration(
                              fillColor: Colors.black12,
                              filled: true,
                              isDense: true,
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              label: const Text(
                                'Age',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: tAadhar,
                            keyboardType: TextInputType.number,
                            maxLength: 12,
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.black12,
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              label: const Text(
                                'Aadhar No.',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (mounted) {
                                setState(
                                  () {
                                    if (picked != null) {
                                      aadharFront = File(picked.path);
                                      aadharFrontName = picked.name;
                                    }
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    aadharFrontName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (mounted) {
                                setState(
                                  () {
                                    if (picked != null) {
                                      aadharBack = File(picked.path);
                                      aadharBackName = picked.name;
                                    }
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                border: Border.all(
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    aadharBackName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.add_photo_alternate,
                                    color: Colors.black87,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: tStartPoint,
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
                                'Start Point',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: tEndPoint,
                            decoration: InputDecoration(
                              isDense: true,
                              filled: true,
                              fillColor: Colors.black12,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              label: const Text(
                                'End Point',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: tRate,
                            keyboardType: TextInputType.number,
                            maxLength: 2,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.black12,
                              counterText: '',
                              isDense: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              label: const Text(
                                'Ticket Rate',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                            child: DropdownButton<String>(
                              value: homeDistrict,
                              isExpanded: true,
                              underline: const SizedBox(),
                              iconEnabledColor: Colors.black,
                              borderRadius: BorderRadius.circular(
                                10,
                              ),
                              dropdownColor: Colors.grey.shade300,
                              items: homeDistricts.map(
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
                                        homeDistrict = value!;
                                        depots = [
                                          "Select Your Depot",
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
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
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
                              onChanged: (String? value) async {
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
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
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
                                        courses = [
                                          "Select Course Or Class",
                                        ];
                                        course = courses[0];
                                        getPlaces();
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
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
                                        courses = [
                                          "Select Course Or Class",
                                        ];
                                        course = courses[0];
                                        getInstitutions();
                                      },
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
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
                                  courses = [
                                    "Select Course Or Class",
                                  ];
                                  course = courses[0];
                                  getCourses();
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
                        value: course,
                        isExpanded: true,
                        underline: const SizedBox(),
                        iconEnabledColor: Colors.black,
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        dropdownColor: Colors.grey.shade300,
                        items: courses.map(
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
                          if (value != courses[0]) {
                            if (mounted) {
                              setState(
                                () {
                                  course = value!;
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
                      child: TextButton(
                        onPressed: apply,
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
    );
  }

  void getDepots() async {
    try {
      final response = await http.post(
        Uri.parse(
          '${api}userGetDepots',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'district': homeDistrict,
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

  void getPlaces() async {
    try {
      final response = await http.post(
        Uri.parse(
          '${api}userGetPlaces',
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
          '${api}userGetInstitutions',
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

  void getCourses() async {
    try {
      final response = await http.post(
        Uri.parse(
          '${api}userGetCourses',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'district': district,
            'place': place,
            'institution': institution,
          },
        ),
      );
      Map data = json.decode(response.body);
      List list = data['courses'];
      if (mounted) {
        setState(
          () {
            courses = courses + list.cast<String>();
          },
        );
      }
    } catch (e) {
      showError("Can't Connect To Network !");
    }
  }

  void apply() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    RegExp specialCharacters = RegExp(r'[!@#\$%^&*()-=+,_.?":{}|<>]');
    RegExp regex = RegExp(r'^[0-9]+$');
    if (tName.text == '') {
      showError("Enter Student Name !");
    } else if (specialCharacters.hasMatch(tName.text)) {
      showError('Enter A Valid Name !');
    } else if (photo == null) {
      showError("Select Photo Of Student !");
    } else if (id == null) {
      showError('Select Id Card Of Student !');
    } else if (tAge.text == '') {
      showError('Enter Student Age !');
    } else if (regex.hasMatch(tAge.text) == false) {
      showError("Enter Correct Age !");
    } else if (int.parse(tAge.text) < 1) {
      showError("Enter Correct Age !");
    } else if (tAadhar.text == '') {
      showError("Enter Aadhar No. Of Student");
    } else if (regex.hasMatch(tAadhar.text) == false) {
      showError("Enter Valid Aadhar No. !");
    } else if (tAadhar.text.length < 8) {
      showError("Enter Valid Aadhar No. !");
    } else if (aadharFront == null) {
      showError("Select Aadhar Front Side Photo !");
    } else if (aadharBack == null) {
      showError("Select Aadhar Back Side Photo !");
    } else if (tStartPoint.text == "") {
      showError("Enter Concession Starting Place !");
    } else if (tEndPoint.text == '') {
      showError("Enter Concession Ending Place !");
    } else if (tRate.text == '') {
      showError("Enter Ksrtc Ticket Cost !");
    } else if (regex.hasMatch(tRate.text) == false) {
      showError("Enter Valid Ticket Rate !");
    } else if (int.parse(tRate.text) < 9) {
      showError("Enter Correct Ticket Rate !");
    } else if (homeDistrict == districts[0]) {
      showError("Select District Of Home");
    } else if (depot == depots[0]) {
      showError("Select Your Depot");
    } else if (district == districts[0]) {
      showError("Select District Of Institution !");
    } else if (place == places[0]) {
      showError("Select Place Of Institution !");
    } else if (institution == institutions[0]) {
      showError("Select Institution !");
    } else if (course == courses[0]) {
      showError("Select Course Or Class !");
    } else {
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        String? username = pref.getString('username');
        var request = http.MultipartRequest(
          "POST",
          Uri.parse(
            '${api}userApplyConcession',
          ),
        );
        request.fields['username'] = username!;
        request.fields['name'] = tName.text;
        request.fields['age'] = tAge.text;
        request.fields['aadhar'] = tAadhar.text;
        request.fields['startPoint'] = tStartPoint.text;
        request.fields['endPoint'] = tEndPoint.text;
        request.fields['rate'] = tRate.text;
        request.fields['homeDistrict'] = homeDistrict;
        request.fields['depot'] = depot;
        request.fields['district'] = district;
        request.fields['place'] = place;
        request.fields['institution'] = institution;
        request.fields['course'] = course;
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            photo!.path,
          ),
        );
        request.files.add(
          await http.MultipartFile.fromPath(
            'id',
            id!.path,
          ),
        );
        request.files.add(
          await http.MultipartFile.fromPath(
            'aadharFront',
            aadharFront!.path,
          ),
        );
        request.files.add(
          await http.MultipartFile.fromPath(
            'aadharBack',
            aadharBack!.path,
          ),
        );
        final response = await request.send();
        var responseData = await response.stream.bytesToString();
        Map data = json.decode(responseData);
        if (data['status'] == 0) {
          showSuccess('Concession Applied');
          if (mounted) {
            setState(
              () {
                Navigator.pop(context);
              },
            );
          }
        } else if (data['status'] == 1) {
          showError("A Application Is Already Registered With Aadhar No !");
        } else {
          showError("Your Approved Concession Has Not Expired !");
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
