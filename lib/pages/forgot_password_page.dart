/*
DateiName: forgot_password_page.dart
Authors: Arkan Kadir (Alles)
Zuletzt bearbeitet am: 08.01.2024
Beschreibung:
  - Die `ForgotPasswordPage` ist eine StatelessWidget, die die Passwort-Wiederherstellungsseite der Anwendung darstellt.
  - Benutzer können ihre E-Mail-Adresse eingeben, um einen Link zum Zurücksetzen ihres Passworts zu erhalten.
  - Die Seite enthält ein Textfeld für die E-Mail-Adresse und einen Button zum Auslösen des Passwort-Zurücksetzen-Prozesses.
  - Der `AuthService` wird verwendet, um die Passwort-Wiederherstellungsfunktion zu implementieren.
  - Das UI-Design ist auf das CODE CARD-Branding abgestimmt, einschließlich des Logos und der Farbpalette.
*/

import 'package:flutter/material.dart';
import 'package:codecard/auth/auth_service.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passwort vergessen'),
        backgroundColor: const Color(0xffff2c293a),
      ),
      body: Container(
        color: const Color(0xffff2c293a),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'CODE CARD',
                  style: TextStyle(
                    fontSize: 70,
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
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'E-Mail Adresse',
                      prefixIcon: const Icon(Icons.mail, color: Colors.white),
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
                  child: ElevatedButton(
                    onPressed: () async {
                      await _authService.resetPassword(emailController.text, context);
                    },
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
                          'Passwort zurücksetzen',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
