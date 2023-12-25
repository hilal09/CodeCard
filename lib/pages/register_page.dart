import 'package:codecard/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:codecard/pages/login_page.dart';
import '../auth/auth_service.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isRegisterTab = false;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late AuthService _authService;

  @override
  void initState() {
    _authService = AuthService();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationWidget(
        isRegisterTab: isRegisterTab,
        onTabChanged: (bool isSelected) {
          setState(() {
            isRegisterTab = isSelected;
          });
        },
        onAuthPressed: () {
          _authService
              .signUpUsingEmailPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          )
              .then((_) {
            // Redirect to DashboardPage after successful registration
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          });
        },
        onLoginPressed: () {
          // Navigate to RegistrationPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        emailController: emailController,
        passwordController: passwordController,
        confirmPasswordController: confirmPasswordController,
      ),
    );
  }
}

class RegistrationWidget extends StatelessWidget {
  final bool isRegisterTab;
  final Function(bool) onTabChanged;
  final VoidCallback onAuthPressed;
  final VoidCallback onLoginPressed;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  RegistrationWidget({
    required this.isRegisterTab,
    required this.onTabChanged,
    required this.onAuthPressed,
    required this.onLoginPressed,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFF2c293a),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 70),
          const Text(
            'CODE CARD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 60,
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  color: Color(0xFFF4cae97),
                  offset: Offset(3.0, 1.0),
                ),
              ],
            ),
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTabButton('Anmelden', false, onLoginPressed),
              const SizedBox(width: 50),
              buildTabButton('Registrieren', true),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: 300,
            child: TextField(
              controller: emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'E-Mail Adresse',
                prefixIcon: const Icon(Icons.mail, color: Colors.white),
                labelStyle: const TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 300,
            child: TextField(
              controller: passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Passwort',
                prefixIcon: const Icon(Icons.lock, color: Colors.white),
                labelStyle: const TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 300,
            child: TextField(
              controller: confirmPasswordController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Passwort wiederholen',
                prefixIcon: const Icon(Icons.lock, color: Colors.white),
                labelStyle: const TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              obscureText: true,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: 300,
            child: ElevatedButton(
              onPressed: onAuthPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: const Color(0xFFFF10111a),
              ),
              child: const SizedBox(
                width: double.infinity,
                child: Center(
                  child: Text(
                    'Bestätigen',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabButton(String text, bool isSelected,
      [VoidCallback? onPressed]) {
    return ElevatedButton(
      onPressed: () {
        onTabChanged(isSelected);
        if (onPressed != null) {
          onPressed();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? const Color(0xFFFF10111a) : const Color(0xFFFF2c293a),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
        ),
      ),
    );
  }
}
