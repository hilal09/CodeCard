import 'package:flutter/material.dart';
import 'package:codecard/widgets/_Folder.dart';

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