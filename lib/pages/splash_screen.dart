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

  // Parameter für horizontale Verschiebung (0 für Zentrierung, positiver Wert für Linksverschiebung)
  final double horizontalShiftCm = 0.3; // Verschiebung in Zentimeter

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

      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _imageAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Umrechnung von cm zu Pixel für die Verschiebung
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
                offset: Offset(-shiftInPixels, 0), // Anpassbare Verschiebung
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
                  'assets/images/SPS.png', // Pfad zu Ihrem Bild
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            FadeTransition(
              opacity:
                  _imageAnimation, // denselben AnimationController für den Text
              child: Text(
                'CODE CARD',
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
            ),
          ],
        ),
      ),
    );
  }
}
