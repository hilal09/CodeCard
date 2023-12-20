import 'package:codecard/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:codecard/widgets/edit_folder.dart';
import 'package:codecard/widgets/folder_widget.dart';
import 'package:codecard/widgets/_CreateFolderFormState.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Folder> folders = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Container(
              width: 70,
              decoration: BoxDecoration(
                color: Color(0xFFFF2c293a),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Color.fromARGB(255, 141, 134, 134),
                  width: 0.5,
                ), // White border
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/Logo.png',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10),
                  IconButton(
                    icon: Icon(Icons.home_rounded, color: Colors.white),
                    onPressed: () {
                      // Action when clicking the Home Icon
                    },
                  ),
                  SizedBox(height: 10),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      _showCreateFolderDialog();
                      // Action when clicking the Add Icon
                    },
                  ),
                  SizedBox(height: 10),
                  // Display folder icons with names in the left bar
                  ...folders.map((folder) => _buildFolderIcon(folder)),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.person, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFF2c293a),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: folders.isEmpty
                    ? Center(
                        child: Text(
                          'Es sind noch keine Stacks vorhanden. Klicke auf das "+"-Symbol, um einen neuen Stack anzulegen.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        itemCount: folders.length,
                        itemBuilder: (context, index) {
                          return FolderWidget(
                            folder: folders[index],
                            onDelete: () => _deleteFolder(index),
                            onEdit: (editedFolder) =>
                                _editFolder(index, editedFolder),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateFolderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Neuen Stack erstellen',
            style: Theme.of(context)
                .textTheme
                .headline6
                ?.copyWith(color: Colors.white),
          ),
          //Farbe muss noch weiß gemacht werden
          contentTextStyle: Theme.of(context).textTheme.bodyText2,
          content: SizedBox(
            height: 320,
            child: CreateFolderForm(
              onCreate: (Folder newFolder) {
                setState(() {
                  folders.add(newFolder);
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  void _deleteFolder(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Stack löschen'),
          content: Text(
              'Bist du sicher, dass du den Stack löschen möchtest? Diese Aktion kann nicht rückgängig gemacht werden.'),
          contentTextStyle: TextStyle(
              color: Colors.white, fontSize: 10), // Hier die Farbe ändern
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 10),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  folders.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: Text('Löschen'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Abbrechen'),
            ),
          ],
        );
      },
    );
  }

  void _editFolder(int index, Folder editedFolder) {
    setState(() {
      folders[index] = editedFolder;
    });
  }

  Widget _buildFolderIcon(Folder folder) {
    return Column(
      children: [
        Icon(
          Icons.folder,
          color: folder.color,
        ),
        SizedBox(height: 5),
        Text(
          folder.name.toLowerCase(),
          style: TextStyle(color: Colors.white, fontSize: 10),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}