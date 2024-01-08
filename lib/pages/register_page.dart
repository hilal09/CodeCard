/* 
DateiName: register_page.dart
Authors: Hilal Cubukcu(UI, E-Mail Verifizierung)
Zuletzt bearbeitet am: 07.01.2024
Beschreibung: Der Dart-Code implementiert eine Registrierungsseite in Flutter, 
die die Firebase-Authentifizierung und Firestore für die Benutzerregistrierung 
nutzt. Benutzer können ihre E-Mail-Adresse und ein Passwort eingeben, und nach 
erfolgreicher Registrierung werden ihre Details in der Firestore-Datenbank gespeichert. 
Die Seite enthält auch Validierungslogik und bietet die Möglichkeit, zwischen 
den Anmelde- und Registrierungstabs zu wechseln.
*/
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codecard/pages/dashboard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:codecard/pages/login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isRegisterTab = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String emailError = "";
  String passwordError = "";
  String confirmPasswordError = "";

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      setState(() {
        confirmPasswordError = "Passwords don't match!";
      });
      return false;
    }
    return true;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    setState(() {
      emailError = "";
      passwordError = "";
      confirmPasswordError = "";
    });

    if (_emailController.text.trim().isEmpty) {
      setState(() {
        emailError = "E-Mail adress is necessary";
      });
      showSnackBar("E-Mail adress is necessary");
      return;
    }

    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        passwordError = "Passwort is necessary";
      });
      showSnackBar("Passwort is necessary");
      return;
    }

    if (!passwordConfirmed()) {
      showSnackBar("Passwords don't match!");
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

      addUserDetails(
        _emailController.text.trim(),
        FirebaseAuth.instance.currentUser!.uid,
      );

      showSnackBar(
          "Registration successful. Please check your email for verification.");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (e) {
      showSnackBar("Registration failed: $e");
    }
  }

  Future<void> addUserDetails(
    String email,
    String uid,
  ) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "E-Mail": email,
      "userID": uid,
    });
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
          signUp();
        },
        onLoginPressed: () {
          // Navigate to RegistrationPage
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        emailController: _emailController,
        passwordController: _passwordController,
        confirmPasswordController: _confirmPasswordController,
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

  const RegistrationWidget({
    super.key,
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
      color: const Color(0xffff2c293a),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 70),
          const Text(
            'CODE CARD',
            style: TextStyle(
              color: Colors.white,
              fontSize: 60,
              shadows: [
                Shadow(
                  blurRadius: 6.0,
                  color: Color(0xfff4cae97),
                  offset: Offset(3.0, 1.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTabButton('Anmelden', false, onLoginPressed),
              const SizedBox(width: 50),
              buildTabButton('Registrieren', true),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
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
          SizedBox(
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
          SizedBox(
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
          SizedBox(
            width: 300,
            child: ElevatedButton(
              onPressed: onAuthPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: const Color(0xffff10111a),
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
            isSelected ? const Color(0xffff10111a) : const Color(0xffff2c293a),
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
