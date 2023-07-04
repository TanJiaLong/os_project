import 'package:flutter/material.dart';
import 'package:os_project/models/user.dart';
import 'package:os_project/views/screens/checkinscreen.dart';
import 'package:os_project/views/screens/locationhistoryscreen.dart';
import 'package:os_project/views/screens/profilescreen.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen({super.key, required this.user});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> tabchildren;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabchildren = [
      CheckInScreen(user: widget.user),
      LocationHistoryScreen(user: widget.user),
      ProfileTabScreen(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabchildren[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.attach_money,
                ),
                label: "GPS"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.gps_fixed,
                ),
                label: "Location History"),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile"),
          ]),
    );
  }

  void onTabTapped(int value) {
    setState(() {
      _currentIndex = value;
    });
  }
}
