import 'dart:async';

import 'package:os_project/loginscreen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //       image: AssetImage('assets/images/splash.jpg'),
              //       fit: BoxFit.cover),
              // ),
              ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "GPS Tracking System",
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 16),
                CircularProgressIndicator(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
