import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ksrtc/main.dart';
import 'package:http/http.dart' as http;

class Institution extends StatefulWidget {
  final int id;
  final String institution;
  final String district;
  final String place;
  const Institution({
    super.key,
    required this.id,
    required this.institution,
    required this.district,
    required this.place,
  });

  @override
  State<Institution> createState() => _InstitutionState();
}

class _InstitutionState extends State<Institution> {
  TextEditingController tInstitution = TextEditingController();
  TextEditingController tPlace = TextEditingController();
  TextEditingController tDistrict = TextEditingController();
  TextEditingController tPassword = TextEditingController();
  List courses = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getInstitution();
  }

  Future<void> getInstitution() async {
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
          '${api}ksrtcGetInstitution',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'id': widget.id,
          },
        ),
      );
      Map data = json.decode(response.body);
      courses = data['courses'];
      tInstitution.text = widget.institution;
      tDistrict.text = widget.district;
      tPlace.text = widget.place;
    } catch (e) {
      showError("Can't Connect To Network !");
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
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 15,
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : RefreshIndicator(
                onRefresh: getInstitution,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Name',
                        ),
                        TextFormField(
                          controller: tInstitution,
                          readOnly: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.black12,
                            isDense: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
                              borderSide: const BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'District',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                controller: tDistrict,
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.black12,
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Place',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextFormField(
                                controller: tPlace,
                                readOnly: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.black12,
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.red.shade900,
                            border: Border.all(
                              color: Colors.black,
                            ),
                            borderRadius: BorderRadius.circular(
                              10,
                            ),
                          ),
                          child: TextButton(
                            onPressed: delete,
                            child: const Text(
                              "Delete",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Courses",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    courses.isEmpty
                        ? const Row(
                            children: [
                              Text(
                                "No Courses Has Been Added To The Institution !",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          )
                        : Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 5,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      courses[index],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: courses.length,
                            ),
                          )
                  ],
                ),
              ),
      ),
    );
  }

  void delete() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    try {
      await http.post(
        Uri.parse(
          '${api}ksrtcDeleteInstitution',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'id': widget.id,
          },
        ),
      );
    } catch (e) {
      showError("Can't Connect To Network !");
    }
    if (mounted) {
      setState(
        () {
          loading = false;
          Navigator.pop(context);
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
