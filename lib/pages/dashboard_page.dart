import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

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
                        'Es sind noch keine Ordner vorhanden. Klicke auf das "+"-Symbol, um einen neuen Ordner anzulegen.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : ListView.builder(
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        return FolderWidget(folder: folders[index]);
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
          title: Text('Neuen Ordner erstellen'),
          content: CreateFolderForm(
            onCreate: (Folder newFolder) {
              setState(() {
                folders.add(newFolder);
              });
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
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
  Color selectedColor = Colors.blue; // Default color

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
                Folder newFolder = Folder(
                  name: nameController.text,
                  description: descriptionController.text,
                  color: selectedColor,
                );
                widget.onCreate(newFolder);
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

class FolderWidget extends StatelessWidget {
  final Folder folder;

  FolderWidget({required this.folder});

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
          Text(folder.name, style: TextStyle(fontSize: 20, color: Colors.white)),
          SizedBox(height: 5),
          Text(folder.description, style: TextStyle(color: Colors.white)),
        ],
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
