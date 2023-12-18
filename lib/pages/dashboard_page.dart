import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Folder> folders = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }

  void _showCreateFolderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Neuen Stack erstellen'),
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
          contentTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 15), //das ist die farbe von "farbe auswählen"
          content: SizedBox(
            height:
                320, // Passe diese Höhe nach Bedarf an "pop up fenster beim stack erstellen"
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

class Folder {
  final String name;
  final String description;
  final Color color;

  Folder({required this.name, required this.description, required this.color});
}

class CreateFolderForm extends StatefulWidget {
  final Function(Folder) onCreate;

  CreateFolderForm({required this.onCreate});

  @override
  _CreateFolderFormState createState() => _CreateFolderFormState();
}

class _CreateFolderFormState extends State<CreateFolderForm> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  Color selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Ordnername'),
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(labelText: 'Beschreibung'),
        ),
        SizedBox(height: 0),
        Text('Farbe auswählen:'),
        Wrap(
          children: [
            _buildColorPicker(Colors.blue),
            _buildColorPicker(Colors.green),
            _buildColorPicker(Colors.yellow),
            _buildColorPicker(Colors.orange),
            _buildColorPicker(Colors.red),
            _buildColorPicker(Colors.purple),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                Folder newFolder = Folder(
                  name: nameController.text,
                  description: descriptionController.text,
                  color: selectedColor,
                );
                widget.onCreate(newFolder);
                Navigator.of(context).pop();
              },
              child: Text('Bestätigen'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorPicker(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 90,
        height: 30,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: selectedColor == color
            ? Icon(Icons.check, color: Colors.white)
            : SizedBox(),
      ),
    );
  }
}

class FolderWidget extends StatelessWidget {
  final Folder folder;
  final VoidCallback onDelete;
  final Function(Folder) onEdit;

  FolderWidget(
      {required this.folder, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: folder.color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(folder.name,
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      _showEditFolderDialog(context);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.white),
                    onPressed: onDelete,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 5),
          Text(folder.description, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void _showEditFolderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Stack bearbeiten'),
          content: EditFolderForm(
            initialFolder: folder,
            onEdit: (editedFolder) {
              onEdit(editedFolder);
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}

class EditFolderForm extends StatefulWidget {
  final Folder initialFolder;
  final Function(Folder) onEdit;

  EditFolderForm({required this.initialFolder, required this.onEdit});

  @override
  _EditFolderFormState createState() => _EditFolderFormState();
}

class _EditFolderFormState extends State<EditFolderForm> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  Color selectedColor = Colors.blue;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialFolder.name);
    descriptionController =
        TextEditingController(text: widget.initialFolder.description);
    selectedColor = widget.initialFolder.color;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'Stackname:'),
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(labelText: 'Beschreibung:'),
        ),
        SizedBox(height: 10),
        Text('Farbe auswählen:'),
        Wrap(
          children: [
            _buildColorPicker(Colors.blue),
            _buildColorPicker(Colors.green),
            _buildColorPicker(Colors.yellow),
            _buildColorPicker(Colors.orange),
            _buildColorPicker(Colors.red),
            _buildColorPicker(Colors.purple),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () {
                Folder editedFolder = Folder(
                  name: nameController.text,
                  description: descriptionController.text,
                  color: selectedColor,
                );
                widget.onEdit(editedFolder);
                Navigator.of(context).pop();
              },
              child: Text('Bestätigen'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColorPicker(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        width: 30,
        height: 30,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: selectedColor == color
            ? Icon(Icons.check, color: Colors.white)
            : SizedBox(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DashboardPage(),
    );
  }
}
