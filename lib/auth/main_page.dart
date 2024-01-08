/*
DateiName: main_page.dart
Authors: Arkan Kadir (Alles)
Zuletzt bearbeitet am: 08.01.2024
Beschreibung:
  - Die `MainPage` ist eine Stateless Widget, die als Einstiegspunkt für die Anwendung dient.
  - Die Seite überwacht den Authentifizierungsstatus des Benutzers mithilfe von Firebase Authentifizierung.
  - Wenn der Benutzer authentifiziert ist (eingeloggt), wird die `DashboardPage` angezeigt.
  - Wenn der Benutzer nicht authentifiziert ist, wird die `LoginPage` angezeigt.
  - Diese Seite ermöglicht die Navigation zwischen dem Dashboard und der Login-Seite basierend auf dem Authentifizierungsstatus.
*/

import 'package:codecard/pages/dashboard_page.dart';
import 'package:codecard/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return DashboardPage();
          } else {
            return LoginPage();
          }
        },
      ),
    );
  }
}
