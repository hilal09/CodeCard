import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
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
                      title: Text('Profil',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onTap: () {
                        // Aktion beim Klicken von Dashboard Widget
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.widgets, color: Colors.white),
                      title: Text('Stapel',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onTap: () {
                        // Aktion bei Klicken auf Stapel Widget
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: Text('Hinzufügen',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onTap: () {
                        // Aktion bei Klicken auf Hinzufügen Widget
                      },
                    ),
                    Spacer(), // Fügt leeren Raum am Ende der Spalte hinzu
                    ListTile(
                      leading: Icon(Icons.person, color: Colors.white),
                      title: Text('Profil',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onTap: () {
                        // Aktion beim Klicken des Profil-ListTiles
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width:
                    20, // Fügt einen Abstand zwischen dem Container und dem Rest der Seite hinzu
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(30),
                  ),
                  // Hier können Sie den Inhalt für den Hauptbereich der Seite platzieren
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 25 + 17, // Adjusted to move down by approximately 1.7 cm
          right: 30, // Roughly 2.5cm to the right (adjust as needed)
          child: GestureDetector(
            onTap: () {
              // Aktion beim Klicken des Hilfsbuttons
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300], // Graue/Weiße Farbe für den Button
              ),
              child: Icon(
                Icons.help,
                color: Colors.grey[800],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
