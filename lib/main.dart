import 'package:flutter/material.dart';
import 'package:os_project/splashscreen.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(
      //     primarySwatch: Colors.red,
      //     brightness: Brightness.light,
      //     textTheme:
      //         GoogleFonts.anticTextTheme(Theme.of(context).textTheme.apply())),
      title: 'Os_Project',
      home: SplashScreen(),
    );
  }
}
// }
