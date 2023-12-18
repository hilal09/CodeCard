import 'package:flutter/material.dart';
import 'package:codecard/pages/register_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginTab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CODE CARD',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF2c293a),
        elevation: 0,
      ),
      body: AuthWidget(
        isLoginTab: isLoginTab,
        onTabChanged: (bool isSelected) {
          setState(() {
            isLoginTab = isSelected;
          });
        },
        onAuthPressed: () {
          // anmeldelogik fehlt
          print('Anmeldung erfolgreich!');
        },
        onRegisterPressed: () {
          // Navigate to RegistrationPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RegistrationPage()),
          );
        },
        onLoginPressed: () {
          // Navigate to LoginPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    );
  }
}

class AuthWidget extends StatelessWidget {
  final bool isLoginTab;
  final Function(bool) onTabChanged;
  final VoidCallback onAuthPressed;
  final VoidCallback onRegisterPressed;
  final VoidCallback onLoginPressed;

  AuthWidget({
    required this.isLoginTab,
    required this.onTabChanged,
    required this.onAuthPressed,
    required this.onRegisterPressed,
    required this.onLoginPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFF2c293a),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTabButton('Anmelden', true, onLoginPressed),
              const SizedBox(width: 50),
              buildTabButton('Registrieren', false, onRegisterPressed),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: 300,
            child: TextField(
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
