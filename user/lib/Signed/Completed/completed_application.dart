import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:user/main.dart';
import 'package:http/http.dart' as http;

class CompletedApplication extends StatefulWidget {
  final String aadhar;
  final Uint8List photo;
  final String name;
  final int primaryKey;
  const CompletedApplication({
    super.key,
    required this.aadhar,
    required this.photo,
    required this.name,
    required this.primaryKey,
  });

  @override
  State<CompletedApplication> createState() => _CompletedApplicationState();
}

class _CompletedApplicationState extends State<CompletedApplication> {
  TextEditingController tName = TextEditingController();
  TextEditingController tAadhar = TextEditingController();
  TextEditingController tAge = TextEditingController();
  TextEditingController tStartPoint = TextEditingController();
  TextEditingController tEndPoint = TextEditingController();
  TextEditingController tRate = TextEditingController();
  TextEditingController tCourse = TextEditingController();
  TextEditingController tInstitution = TextEditingController();
  Map application = {};
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getApplication();
  }

  Future<void> getApplication() async {
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
          '${api}userGetCompletedApplication',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'primaryKey': widget.primaryKey,
          },
        ),
      );
      Map data = json.decode(response.body);
      application = data['application'];
      tName.text = widget.name;
      tAadhar.text = widget.aadhar;
      tAge.text = application['age'];
      tStartPoint.text = application['startPoint'];
      tEndPoint.text = application['endPoint'];
      tRate.text = application['rate'];
      tCourse.text = application['course'];
      tInstitution.text = "${application['institution']},\n${application['place']},${application['district']}";
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
                onRefresh: getApplication,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showImage(widget.photo);
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              padding: const EdgeInsets.all(
                                5,
                              ),
                              child: Image.memory(
                                widget.photo,
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              showImage(base64Decode(application['id']));
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                              padding: const EdgeInsets.all(
                                5,
                              ),
                              child: Image.memory(
                                base64Decode(application['id']),
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                            controller: tName,
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
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Aadhar',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                  controller: tAadhar,
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
                                  'Age',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                  controller: tAge,
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
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                showImage(base64Decode(application['aadharFront']));
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Aadhar Front",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.image,
                                      color: Colors.black,
                                    )
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
                              onTap: () {
                                showImage(base64Decode(application['aadharBack']));
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Aadhar Back",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Icon(
                                      Icons.image,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
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
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Start Point',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                  controller: tStartPoint,
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
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'End Point',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                  controller: tEndPoint,
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
                                  'Ticket Rate',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                  controller: tRate,
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
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Course / Class',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                TextFormField(
                                  controller: tCourse,
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
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'College / School',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextFormField(
                            controller: tInstitution,
                            readOnly: true,
                            maxLines: 2,
                            minLines: 2,
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
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: Visibility(
        visible: !loading,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.green.shade900,
            borderRadius: BorderRadius.circular(
              5,
            ),
          ),
          child: TextButton(
            onPressed: download,
            child: const Text(
              'Download',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void download() async {
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
          '${api}userDownloadConcession',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'primaryKey': widget.primaryKey,
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
        },
      );
    }
  }

  void showImage(Uint8List image) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            child: Image.memory(
              image,
              fit: BoxFit.scaleDown,
            ),
          ),
        );
      },
    );
  }

  void showError(String error) {
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
