import 'package:codecard/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:codecard/pages/profile_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:codecard/pages/register_page.dart';
import 'package:codecard/pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.sourceCodeProTextTheme().copyWith(),
      ),
      home: Scaffold(
        body: DashboardPage(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward(); //  Animation, sobald der Screen erstellt wird

    // Verzögerung von 3 Sekunden
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Hintergrundfarbe des Splash Screens
      body: Center(
        child: Opacity(
          opacity: _animation.value,
          child: Text(
            '</> CodeCard',
            style: TextStyle(
              fontSize: 55,
              color: Colors.tealAccent,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Ressourcen freigeben
    super.dispose();
  }
}
