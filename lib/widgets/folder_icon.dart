/* 
DateiName: folder_icon.dart
Authors: Hilal Cubukcu(alles)
Zuletzt bearbeitet am: 07.01.2024
Beschreibung: Dieser Flutter-Code implementiert ein anpassbares FolderIcon-Widget, 
das ein farbiges Icon-Element mit einer Textabkürzung für Ordner- oder 
Dateinamen darstellt. Dieses Widget ist interaktiv und ruft eine spezifizierte 
Funktion (onTap) auf, wenn darauf getippt wird.
*/

import 'package:flutter/material.dart';

class FolderIcon extends StatelessWidget {
  final String folderName;
  final Color folderColor;
  final Function onTap;

  const FolderIcon({
    required this.folderName,
    required this.folderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayText =
        folderName.length > 3 ? folderName.substring(0, 4) : folderName;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: () => onTap(),
        child: Column(
          children: [
            Icon(
              Icons.folder,
              color: folderColor,
              size: 45,
            ),
            Text(
              displayText,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
