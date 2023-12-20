import 'package:flutter/material.dart';
import 'package:codecard/widgets/edit_folder.dart';
import 'package:codecard/widgets/_CreateFolderFormState.dart';

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