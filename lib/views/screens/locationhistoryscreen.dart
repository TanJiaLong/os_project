import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:os_project/models/locations.dart';
import 'package:os_project/models/user.dart';
import 'package:os_project/myconfig.dart';

class LocationHistoryScreen extends StatefulWidget {
  final User user;
  const LocationHistoryScreen({super.key, required this.user});

  @override
  State<LocationHistoryScreen> createState() => _LocationHistoryScreenState();
}

class _LocationHistoryScreenState extends State<LocationHistoryScreen> {
  List<Locations> locationList = <Locations>[];
  late double screenHeight, screenWidth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLocation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location History"),
      ),
      body: Column(
        children: [
          locationList.isEmpty
              ? const Center(
                  child: Text("No location history yet"),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: locationList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onLongPress: () {},
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                height: 0.1 * screenHeight,
                                width: 0.2 * screenWidth,
                                child: Image.asset(
                                  "assets/images/location_logo.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Flexible(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${locationList[index].locality}, ${locationList[index].state}",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "Latitude\t\t: ${locationList[index].latitude.toString()}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "Longitude\t\t: ${locationList[index].longitude.toString()}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "Check-In Date\t\t: ${locationList[index].checkInDate.toString()}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    onDeleteDialog(index);
                                  },
                                  icon: const Icon(Icons.delete)),
                            ],
                          ),
                        )),
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }

  void loadLocation() {
    http.post(Uri.parse("${MyConfig.SERVER}/os_project/php/load_location.php"),
        body: {
          'user_id': widget.user.id,
        }).then((response) {
      log(response.body);
      locationList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          var extractdata = jsondata['data'];
          extractdata['locations'].forEach((element) {
            locationList.add(Locations.fromJson(element));
          });
        }
      }
      setState(() {});
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Delete?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteLocationHistory(index);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void deleteLocationHistory(int index) {
    http.post(
        Uri.parse("${MyConfig.SERVER}/os_project/php/delete_location.php"),
        body: {"locationId": locationList[index].locationId}).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loadLocation();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }
}
