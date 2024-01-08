/* 
DateiName: dashboard_page.dart
Authors: Hilal Cubukcu(UI), Amara Akram (erstes UI, Grid), Ceyda Sarioglu (UI, Funktionalitäten)
Zuletzt bearbeitet am: 08.01.2024
Beschreibung: Haupt-Dashboard für unsere Lernkarten-App. Es ermöglicht Benutzern, ihre persönlichen Lernkartenordner (Folders) zu verwalten und anzuzeigen.
Die Logik und die Darstellung der Ordner und ihrer Interaktionsmöglichkeiten:
 - Initialisierung und Verwaltung einer Liste von Ordnern, die aus einer Firestore-Datenbank abgerufen werden.
 - Die Funktion `fetchUserFolders` ruft die Ordner des aktuellen Benutzers ab und speichert sie in einem lokalen Zustand.
 - Dialogfunktionen zum Erstellen, Bearbeiten und Löschen von Ordnern.
 - Die Funktion `_showFolderCreatedSnackbar` zeigt eine Snackbar-Benachrichtigung an, wenn ein neuer Ordner erstellt oder ein bestehender bearbeitet wird.
 - Das Rendering von Ordnertiles (`_buildFolderTile`), die auf Berührung den Benutzer zur FlashcardPage des jeweiligen Ordners führen.
 - Eine Suchleiste ermöglicht es Benutzern, ihre Ordnerliste basierend auf dem Suchbegriff zu filtern.
 Diese Seite bildet das zentrale Interface für die Benutzerinteraktion mit Lernkarten und Ordnern.
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codecard/pages/flashcard_page.dart';
import 'package:codecard/widgets/colorpicker.dart';
import 'package:codecard/widgets/folder.dart';
import 'package:codecard/widgets/suchleiste.dart';
import 'package:codecard/widgets/left_sidebar.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<Folder> folders;
  late String searchTerm;
  late TextEditingController folderNameController;
  late Color selectedColor;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    searchTerm = "";
    authService = AuthService();
    folderNameController = TextEditingController();
    selectedColor = const Color(0xffff69597);
    folders = [];
    fetchUserFolders();
  }

  @override
  void dispose() {
    folderNameController.dispose();
    super.dispose();
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
        });
      } catch (e) {
        print('Error fetching user folders: $e');
      }
    }
  }

  void _showFolderCreatedSnackbar(Folder folder) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlashcardPage(folder: folder),
              ),
            );
          },
          child: Container(
            height: 60,
            decoration: BoxDecoration(
              color: folder.color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                folder.name,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Future<void> _showCreateFolderDialog({Folder? existingFolder}) async {
    folderNameController.text = existingFolder?.name ?? "";
    selectedColor = existingFolder?.color ?? const Color(0xffffe69597);

    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    final authService = AuthService();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            existingFolder == null ? "Erstelle ein Set" : "Bearbeite das Set",
            style: const TextStyle(color: Colors.white),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: folderNameController,
                    maxLength: 35,
                    onChanged: (value) {
                      setState(() {
                        formKey.currentState?.validate();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Trage einen Namen für das Set ein.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Name des Sets',
                      counterText: "",
                      errorText: formKey.currentState?.validate() == false
                          ? 'Trage einen Namen für das Set ein.'
                          : null,
                      labelStyle: const TextStyle(color: Colors.white),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle: const TextStyle(color: Colors.white),
                      suffixStyle: const TextStyle(color: Colors.white),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Wähle eine Farbe aus:",
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  ColorPicker(
                    initialColor: selectedColor,
                    onColorSelected: (color) {
                      selectedColor = color;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Abbrechen',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final name = folderNameController.text;
                    final color = selectedColor;
                    final uid = authService.currentUserUID();

                    final folderData = {
                      'name': name,
                      'color': color.value,
                      'userUID': uid,
                    };

                    if (existingFolder == null) {
                      final docRef = await FirebaseFirestore.instance
                          .collection('users')
                          .doc(uid)
                          .collection('folders')
                          .add(folderData);
                      final newFolder =
                          Folder(name: name, color: color, id: docRef.id);
                      setState(() {
                        folders.insert(0, newFolder);
                      });
                    } else {
                      await FirebaseFirestore.instance
                          .collection('folders')
                          .doc(existingFolder.id)
                          .update(folderData);
                      final updatedFolder = Folder(
                          name: name, color: color, id: existingFolder.id);
                      final index = folders.indexWhere(
                          (folder) => folder.id == existingFolder.id);
                      setState(() {
                        folders[index] = updatedFolder;
                      });
                    }

                    Navigator.of(context).pop();

                    _showFolderCreatedSnackbar(
                        Folder(name: name, color: color, id: ''));
                  },
                  child: Text(
                    existingFolder == null ? 'Erstellen' : 'Bearbeiten',
                    style: const TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteFolderDialog(Folder folder) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              const Text(style: TextStyle(color: Colors.white), 'Set löschen'),
          content: const Text(
              style: TextStyle(color: Colors.white),
              'Bist du dir sicher, dass du das Set löschen möchtest?'),
          actions: [
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Abbrechen',
                      style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      folders.remove(folder);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('Löschen',
                      style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildFolderTile(Folder folder) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FlashcardPage(folder: folder),
          ),
        );
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: folder.color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 1,
                    child: Text("Bearbeiten"),
                  ),
                  const PopupMenuItem(
                    value: 2,
                    child: Text("Löschen"),
                  ),
                ],
                onSelected: (value) {
                  if (value == 1) {
                    _showCreateFolderDialog(existingFolder: folder);
                  } else if (value == 2) {
                    _showDeleteFolderDialog(folder);
                  }
                },
              ),
            ),
          ),
          Center(
            child: Text(
              folder.name,
              style: const TextStyle(
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(2.0, 2.0),
                    blurRadius: 3.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFolderMessage() {
    return const SizedBox(
      height: 450,
      child: Center(
        child: Text(
          'Klick auf das + Zeichen, um ein neues Set zu erstellen.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const LeftSideBar(),
            const SizedBox(width: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xffff2c293a),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Spacer(), // New spacer
                        Flexible(
                          child: Suchleiste(
                            onSearch: (term) {
                              setState(() {
                                searchTerm = term;
                              });
                            },
                          ),
                        ),
                        Spacer(), // New spacer
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 96, 92, 100),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.add, color: Colors.black),
                            onPressed: () {
                              _showCreateFolderDialog();
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    folders.isEmpty
                        ? _buildEmptyFolderMessage()
                        : Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: folders
                                  .where((folder) => folder.name
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase()))
                                  .length,
                              itemBuilder: (BuildContext context, int index) {
                                Folder folder = folders
                                    .where((folder) => folder.name
                                        .toLowerCase()
                                        .contains(searchTerm.toLowerCase()))
                                    .toList()[index];
                                return _buildFolderTile(folder);
                              },
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
