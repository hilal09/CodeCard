import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

 @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 500,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Row(
            children: [
              Container(
                width: 250,
                color: Colors.grey[800],
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
                        // Aktion beim klicken von Dashboard Widget
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.widgets, color: Colors.white),
                      title: Text('Stapel',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onTap: () {
                        // Aktion bei klicken auf Stapel Widget
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.add, color: Colors.white),
                      title: Text('Hinzufügen',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      onTap: () {
                        // Aktion bei klicken auf Hinzufügen Widget
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}