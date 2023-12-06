import 'package:flutter/material.dart';

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
          'Code Card',
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
      ),
    );
  }
}

class AuthWidget extends StatelessWidget {
  final bool isLoginTab;
  final Function(bool) onTabChanged;
  final VoidCallback onAuthPressed;

  AuthWidget({
    required this.isLoginTab,
    required this.onTabChanged,
    required this.onAuthPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2c293a),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildTabButton('Login', true),
              buildTabButton('Register', false),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'E-Mail Address',
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
          const SizedBox(height: 20),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Password',
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onAuthPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: const Color(0xFF10111a),
            ),
            child: const SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(
                  'Authenticate',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabButton(String text, bool isSelected) {
    return ElevatedButton(
      onPressed: () {
        onTabChanged(isSelected);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF10111a) : const Color(0xFF2c293a),
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
