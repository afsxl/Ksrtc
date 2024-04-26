import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:user/main.dart';
import 'package:http/http.dart' as http;

class Application extends StatefulWidget {
  final String aadhar;
  final Uint8List photo;
  final String name;
  const Application({
    super.key,
    required this.aadhar,
    required this.photo,
    required this.name,
  });

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
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
  int downloadVisible = 0;
  String cost = '';

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
          '${api}userGetApplication',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'aadhar': widget.aadhar,
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
      downloadVisible = application['ksrtcApproval'];
      if (downloadVisible == 1) {
        cost = application['cost'];
      }
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
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: application['hodApproval'] == 0
                                    ? Colors.grey.shade700
                                    : application['hodApproval'] == 1
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Hod / Teacher',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    application['hodApproval'] == 0
                                        ? "Not Viewed"
                                        : application['hodApproval'] == 1
                                            ? "Approved"
                                            : "Rejected",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: application['institutionApproval'] == 0
                                    ? Colors.grey.shade700
                                    : application['institutionApproval'] == 1
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Principal',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    application['institutionApproval'] == 0
                                        ? "Not Viewed"
                                        : application['institutionApproval'] == 1
                                            ? "Approved"
                                            : "Rejected",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: application['ksrtcApproval'] == 0
                                    ? Colors.grey.shade700
                                    : application['ksrtcApproval'] == 1
                                        ? Colors.green.shade700
                                        : Colors.red.shade700,
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Ksrtc',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    application['ksrtcApproval'] == 0
                                        ? "Not Viewed"
                                        : application['ksrtcApproval'] == 1
                                            ? "Approved"
                                            : "Rejected",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
      bottomNavigationBar: Visibility(
        visible: !loading,
        child: Row(
          children: [
            if (downloadVisible == 0 || downloadVisible == -1)
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade900,
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                  ),
                  child: TextButton(
                    onPressed: delete,
                    child: const Text(
                      'Delete Application',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            if (downloadVisible == 1)
              Expanded(
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
          ],
        ),
      ),
    );
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

  void delete() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Do You Want To Delete",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  const Text(
                    "The Application ?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.green.shade900,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "No",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.red.shade900,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            deleteApplication();
                          },
                          child: const Text(
                            "Yes",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void deleteApplication() async {
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
          '${api}userDeleteApplication',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'aadhar': widget.aadhar,
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
          showSuccess("Application Deleted");
        },
      );
    }
  }

  void download() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(
                  10,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Pay Amount : $cost",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.red.shade900,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.green.shade900,
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            pay();
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Pay",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void pay() async {
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
          '${api}userPay',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'aadhar': widget.aadhar,
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
