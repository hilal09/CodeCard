import 'package:codecard/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await Supabase.initialize(
    url: 'https://uqdlcgvlokejuxhbliro.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVxZGxjZ3Zsb2tlanV4aGJsaXJvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMwODc4MjUsImV4cCI6MjAxODY2MzgyNX0.tTtYS2nfF9R2g4OZs1YYETtwnRe5ZmXecZFbK1gu53Y',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.sourceCodeProTextTheme().copyWith(),
      ),
      home: const Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}
