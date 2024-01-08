/* 
DateiName: splash_screen.dart
Authors: Amara Akram(alles)
Zuletzt bearbeitet am: 07.01.2024
Beschreibung: 
Dieses Flutter StatefulWidget repräsentiert einen Startbildschirm für unsere Karteikartenapp "CODE CARD".
Es beinhaltet Animationen für Text und Bilder, um eine dynamische und ansprechende Einführung in die App zu gewährleisten.
Der Bildschirm beginnt mit einer Animation, bei der ein Set von hüpfenden Bällen (mittels einer Lottie-Animation) ausgeblendet wird,
gefolgt vom Einblenden des App-Logos. Vom Beginn der ersten bis zum Ende der zweiten Animationen folgt die Textanimation des Namens "CODE CARD",
bei der jeder Buchstabe nacheinander eingeblendet wird. Die gesamte Animationssequenz ist auf 3 Sekunden festgelegt,
bevor automatisch zur `LoginPage` navigiert wird. Dieses Widget beinhaltet auch gerätespezifische Berechnungen,
um eine korrekte Ausrichtung und Skalierung auf verschiedenen Geräten zu gewährleisten.
*/

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_page.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _imageAnimationController;
  late Animation<double> _imageAnimation;
  bool _showImage = false;

  final double horizontalShiftCm =
      0.4; // Verschiebung in Zentimeter, damit die bälle optisch in der mitte sind

  late AnimationController _textAnimationController;
  List<Animation<double>> _letterAnimations = [];
  final String text = 'CODE CARD';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animationController);

    _imageAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _imageAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_imageAnimationController);

    _animationController.forward().then((_) {
      setState(() {
        _showImage = true;
      });
      _imageAnimationController.forward();

      Future.delayed(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    });

    // Text Animation
    _textAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Gesamtdauer für den Text
    );

    int totalLetters = text.length;
    for (int i = 0; i < totalLetters; i++) {
      // Das Interval für jeden Buchstaben anpassen
      double start = i / totalLetters;
      double end = (i + 1) / totalLetters;
      _letterAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _textAnimationController,
            curve: Interval(start, end, curve: Curves.easeIn),
          ),
        ),
      );
    }

    _textAnimationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _imageAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double shiftInPixels = MediaQuery.of(context).devicePixelRatio *
        37.7952755906 *
        horizontalShiftCm;

    return Scaffold(
      backgroundColor: const Color(0xffff2c293a),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!_showImage)
              Transform.translate(
                offset: Offset(-shiftInPixels, 0),
                child: FadeTransition(
                  opacity: _animation,
                  child: Lottie.asset(
                    'assets/images/balls.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            if (_showImage)
              FadeTransition(
                opacity: _imageAnimation,
                child: Image.asset(
                  'assets/images/SPSLogo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: _letterAnimations.asMap().entries.map((entry) {
                int idx = entry.key;
                Animation<double> animation = entry.value;
                return FadeTransition(
                  opacity: animation,
                  child: Text(
                    text[idx],
                    style: GoogleFonts.sourceCodePro(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        shadows: [
                          Shadow(
                            blurRadius: 6.0,
                            color: Color(0xfff4cae97),
                            offset: Offset(3.0, 1.0),
                          ),
                        ],
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
