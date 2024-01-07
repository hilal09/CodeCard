/* 
DateiName: left_sidebar.dart
Authors: Hilal Cubukcu(alles)
Zuletzt bearbeitet am: 07.01.2024
Beschreibung: Diese Datei implementiert eine linke Seitenleiste (LeftSideBar),
die eine dynamische Liste von FolderIcons basierend auf Benutzerordnern darstellt. 
Jedes FolderIcon repräsentiert einen Ordner und ermöglicht den Benutzern den 
Zugriff auf die entsprechende Seite für die Blitzkarten dieses Ordners. Die 
Seitenleiste enthält auch Symbole für die Startseite (DashboardPage) und 
das Benutzerprofil (ProfilePage).
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codecard/auth/auth_service.dart';
import 'package:codecard/pages/flashcard_page.dart';
import 'package:codecard/pages/profile_page.dart';
import 'package:codecard/widgets/folder.dart';
import 'package:codecard/widgets/folder_icon.dart';
import 'package:flutter/material.dart';
import 'package:codecard/pages/dashboard_page.dart';

class LeftSideBar extends StatefulWidget {
  final Function()? onFolderAdded;

  const LeftSideBar({Key? key, this.onFolderAdded}) : super(key: key);

  @override
  _LeftSideBarState createState() => _LeftSideBarState();
}

class _LeftSideBarState extends State<LeftSideBar> {
  List<FolderIcon> folderIcons = [];
  late List<Folder> folders;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    authService = AuthService();
    fetchUserFolders();
  }

  Future<void> fetchUserFolders() async {
    final uid = authService.currentUserUID();
    if (uid != null) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('folders')
            .get();
        setState(() {
          folders = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return Folder(
              name: data['name'] ?? '',
              color: Color(data['color'] ?? 0),
              id: doc.id,
            );
          }).toList();

          // Update folderIcons based on fetched folders
          folderIcons = folders.map((folder) {
            return FolderIcon(
              folderName: folder.name,
              folderColor: folder.color, // Pass the color to FolderIcon
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlashcardPage(folder: folder),
                  ),
                );
              },
            );
          }).toList();
        });

        // Call the onFolderAdded callback if provided
        if (widget.onFolderAdded != null) {
          widget.onFolderAdded!();
        }
      } catch (e) {
        print('Error fetching user folders: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      decoration: BoxDecoration(
        color: const Color(0xffff2c293a),
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: const Color.fromARGB(255, 141, 134, 134),
          width: 0.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/images/Logo.png',
              height: 50,
              width: 50,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          IconButton(
            icon: const Icon(Icons.home_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DashboardPage()),
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: folderIcons,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
