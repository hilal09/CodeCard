import 'package:codecard/pages/flashcard_page.dart';
import 'package:codecard/pages/splash_screen.dart';
import 'package:codecard/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:codecard/pages/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:codecard/pages/register_page.dart';
import 'package:codecard/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.sourceCodeProTextTheme().copyWith(),
      ),
      home: Scaffold(
        body: ProfilePage(), //home: const SplashScreen(),
      ),
    );
  }
}
