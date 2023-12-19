import 'package:flutter/material.dart';
import 'package:codecard/pages/dashboard_page.dart';

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
