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
        body: LoginPage(),
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

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Suche...',
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 250,
                color: Colors.grey[800],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      height: 60,
                      color: Colors.blue,
                      child: const Center(
                        child: Text(
                          'CodeCard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'YourFont',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: Icon(Icons.dashboard, color: Colors.white),
                      title: Text('Dashboard',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onTap: () {
                        // Aktion beim klicken von Dashboard Widget
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.widgets, color: Colors.white),
                      title: Text('Stapel',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onTap: () {
                        // Aktion bei klicken auf Stapel Widget
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: Text('Hinzufügen',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onTap: () {
                        // Aktion bei klicken auf Hinzufügen Widget
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CardWidget(),
                      CardWidget(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CardWidget extends StatefulWidget {
  const CardWidget({Key? key}) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  final TextEditingController textController = TextEditingController();
  String cardText = '';

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDialog();
      },
      child: Container(
        width: 400,
        height: 250,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[700]!,
          ),
        ),
        child: Center(
          child: Text(
            cardText.isNotEmpty ? cardText : '+',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erstelle Stapel'),
          content: TextFormField(
            controller: textController,
            decoration: InputDecoration(hintText: 'Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  cardText = textController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Speichern'),
            ),
          ],
        );
      },
    );
  }
}
