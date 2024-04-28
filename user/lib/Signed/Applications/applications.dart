import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Signed/Applications/application.dart';
import 'package:user/main.dart';
import 'package:http/http.dart' as http;

class Applications extends StatefulWidget {
  const Applications({
    super.key,
  });

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  List applications = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getApplications();
  }

  Future<void> getApplications() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? username = pref.getString('username');
      final response = await http.post(
        Uri.parse(
          '${api}userGetApplications',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'username': username,
          },
        ),
      );
      Map data = json.decode(response.body);
      applications = data['applications'];
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
          vertical: 15,
          horizontal: 20,
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : RefreshIndicator(
                onRefresh: getApplications,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Applications',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    applications.isEmpty
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Applications Found",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          )
                        : Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              itemCount: applications.length,
                              itemBuilder: (context, index) {
                                Uint8List photo = base64Decode(
                                  applications[index]['photo'],
                                );
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black26,
                                    borderRadius: BorderRadius.circular(
                                      10,
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 5,
                                  ),
                                  child: ListTile(
                                    onTap: () async {
                                      await Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (ctx) {
                                            return Application(
                                              aadhar: applications[index]['aadhar'],
                                              photo: photo,
                                              name: applications[index]['name'],
                                            );
                                          },
                                        ),
                                      );
                                      getApplications();
                                    },
                                    title: Text(
                                      applications[index]['name'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    leading: Image.memory(
                                      photo,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    subtitle: Text(
                                      applications[index]['aadhar'],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 20,
                                );
                              },
                            ),
                          )
                  ],
                ),
              ),
      ),
    );
  }

  void showError(String error) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(
            seconds: 1,
          ),
          backgroundColor: Colors.red.shade900,
          margin: const EdgeInsets.all(
            20,
          ),
          behavior: SnackBarBehavior.floating,
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
