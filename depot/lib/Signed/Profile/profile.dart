import 'dart:convert';
import 'package:depot/Not%20Signed/signin.dart';
import 'package:depot/Signed/Profile/change_password.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:depot/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController tDepot = TextEditingController();
  TextEditingController tDistrict = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    tDistrict.text = '';
    tDepot.text = '';
    loading = false;
    getProfile();
  }

  void getProfile() async {
    if (mounted) {
      setState(
        () {
          loading = true;
        },
      );
    }
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? id = pref.getString('id');
      final response = await http.post(
        Uri.parse(
          '${api}depotGetProfile',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'id': id,
          },
        ),
      );
      Map data = json.decode(response.body);
      Map profile = data['profile'];
      tDepot.text = profile['depot'];
      tDistrict.text = profile['district'];
    } catch (e) {
      showError("Can't Connect To Server !");
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
          "Ksrtc Concession",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(
          20,
        ),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Depot Name',
                    ),
                    TextFormField(
                      controller: tDepot,
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black12,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'District',
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
                            10,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            10,
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
                        onPressed: changePassword,
                        child: const Text(
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          'Change Password',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black26,
        ),
        child: TextButton(
          onPressed: logout,
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  void logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('logged', false);
    pref.setString('id', '');
    pref.setString('password', '');
    if (mounted) {
      setState(
        () {
          Navigator.popUntil(
            context,
            (route) => false,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) {
                return const SignIn();
              },
            ),
          );
        },
      );
    }
  }

  void changePassword() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return const ChangePassword();
        },
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
