import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ksrtc/main.dart';

class Depots extends StatefulWidget {
  const Depots({
    super.key,
  });

  @override
  State<Depots> createState() => _DepotsState();
}

class _DepotsState extends State<Depots> {
  bool loading = false;
  List depots = [];

  @override
  void initState() {
    super.initState();
    getDepots();
  }

  Future<void> getDepots() async {
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
          '${api}ksrtcGetDepots',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {},
        ),
      );
      Map data = json.decode(response.body);
      depots = data['depots'];
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
                onRefresh: getDepots,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Depots',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    depots.isEmpty
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Depots Found",
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
                              itemCount: depots.length,
                              itemBuilder: (context, index) {
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
                                    title: Row(
                                      children: [
                                        const Text(
                                          'Depot Name : ',
                                        ),
                                        Text(
                                          depots[index]['depot'],
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              'District : ',
                                            ),
                                            Text(
                                              depots[index]['district'],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              'Password : ',
                                            ),
                                            Text(
                                              depots[index]['password'],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        delete(index);
                                      },
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.red.shade900,
                                          ),
                                          Text(
                                            'Delete',
                                            style: TextStyle(
                                              color: Colors.red.shade900,
                                            ),
                                          ),
                                        ],
                                      ),
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

  void delete(int index) async {
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
                    "The Course ?",
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
                            deleteCourse(index);
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

  void deleteCourse(int index) async {
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
          '${api}ksrtcDeleteDepot',
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'id': depots[index]['id'],
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
          getDepots();
          showSuccess("Depot Removed");
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
