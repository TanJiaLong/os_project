import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:os_project/models/user.dart';
import 'package:os_project/myconfig.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CheckInScreen extends StatefulWidget {
  final User user;
  const CheckInScreen({super.key, required this.user});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  late double screenHeight, screenWidth, cardwitdh;
  final _formKey = GlobalKey<FormState>();
  late Position _currentPosition;
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  final TextEditingController _prlatEditingController = TextEditingController();
  final TextEditingController _prlongEditingController =
      TextEditingController();

  String CheckInScreenTime = '';

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Check In"), actions: [
        IconButton(
            onPressed: () {
              _determinePosition();
            },
            icon: const Icon(Icons.refresh))
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                color: const Color.fromRGBO(240, 230, 140, 2),
                minWidth: 100,
                height: 35,
                elevation: 10,
                onPressed: () {
                  insertDialog();
                },
                child: const Text(
                  "Check In",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 20),
            Text(
              'Check-In Time: $CheckInScreenTime',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Flexible(
                flex: 5,
                child: TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (val) => val!.isEmpty || (val.length < 3)
                        ? "Current State"
                        : null,
                    enabled: false,
                    controller: _prstateEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: 'Current State',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.flag),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ))),
              ),
              Flexible(
                flex: 5,
                child: TextFormField(
                    textInputAction: TextInputAction.next,
                    enabled: false,
                    validator: (val) => val!.isEmpty || (val.length < 3)
                        ? "Current Locality"
                        : null,
                    controller: _prlocalEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: 'Current Locality',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.map),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ))),
              ),
            ]),
            Row(children: [
              Flexible(
                flex: 5,
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  enabled: false,
                  controller: _prlatEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Latitude',
                    labelStyle: TextStyle(),
                    icon: Icon(Icons.gps_fixed),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 5,
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  enabled: false,
                  controller: _prlongEditingController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Longitude',
                    labelStyle: TextStyle(),
                    icon: Icon(Icons.gps_fixed),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 2.0),
                    ),
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  void insertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Check in?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                insertDetails();
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

  void insertDetails() async {
    String state = _prstateEditingController.text;
    String locality = _prlocalEditingController.text;
    String prlat = _prlatEditingController.text;
    String prlong = _prlongEditingController.text;

    http.post(Uri.parse("${MyConfig.SERVER}/os_project/php/user_details.php"),
        body: {
          "userId": widget.user.id,
          "latitude": prlat,
          "longitude": prlong,
          "state": state,
          "locality": locality,
          "checkInTime": CheckInScreenTime,
        }).then((response) {
      log(response.body);
      if (response.statusCode == 200) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _prlocalEditingController.text = "Changlun";
      _prstateEditingController.text = "Kedah";
      _prlatEditingController.text = "6.443455345";
      _prlongEditingController.text = "100.05488449";
    } else {
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      _prlatEditingController.text = pos.latitude.toString();
      _prlongEditingController.text = pos.longitude.toString();
    }
    setState(() {
      final currentTime = DateTime.now();
      final formattedTime = DateFormat('h:mm a').format(currentTime);
      CheckInScreenTime = formattedTime;
    });
  }
}
