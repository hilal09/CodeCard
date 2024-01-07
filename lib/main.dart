import 'package:codecard/pages/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDcHr3qdC4yMiDyqVbhOK-LueK-D9iQHXA",
          authDomain: "codecard-52b0f.firebaseapp.com",
          projectId: "codecard-52b0f",
          storageBucket: "codecard-52b0f.appspot.com",
          messagingSenderId: "935526288022",
          appId: "1:935526288022:web:4f2ce41d960a1aeced10b7"));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.sourceCodeProTextTheme().apply(
          bodyColor: Colors.white,
        ),
      ),
      home: const Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}
