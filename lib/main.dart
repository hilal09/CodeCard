import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/profile_page.dart';

void main() {
  runApp(MaterialApp()); //MaterialApp
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      //Theme für den Stil in der App (alle files haben gleiche font etc.)
      theme: ThemeData(
        fontFamily: GoogleFonts.sourceCodePro().fontFamily,
        primarySwatch: Colors.grey,
      ),
      home: const ProfilePage(title: 'Profile Page'),
    );
  }
}
