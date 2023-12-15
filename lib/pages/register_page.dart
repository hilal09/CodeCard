import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool isRegisterTab = false;

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
      body: RegistrationWidget(
        isRegisterTab: isRegisterTab,
        onTabChanged: (bool isSelected) {
          setState(() {
            isRegisterTab = isSelected;
          });
        },
        onRegisterPressed: () {
          // registrierlogik fehlt
          print('Registrierung erfolgreich!');
        },
      ),
    );
  }
}

class RegistrationWidget extends StatelessWidget {
  final bool isRegisterTab;
  final Function(bool) onTabChanged;
  final VoidCallback onRegisterPressed;

  RegistrationWidget({
    required this.isRegisterTab,
    required this.onTabChanged,
    required this.onRegisterPressed,
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
              buildTabButton('Anmelden', false),
              const SizedBox(width: 50),
              buildTabButton('Registrieren', true),
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
            child: TextField(
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
          const SizedBox(height: 20), // Verringere die Höhe der SizedBox
          Container(
            width: 300,
            child: ElevatedButton(
              onPressed: onRegisterPressed,
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

  Widget buildTabButton(String text, bool isSelected) {
    return ElevatedButton(
      onPressed: () {
        onTabChanged(isSelected);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFFFF10111a) : const Color(0xFFFF2c293a),
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

