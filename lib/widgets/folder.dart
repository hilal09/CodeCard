/* 
DateiName: folder.dart
Authors: Hilal Cubukcu(alles, außer id)
Zuletzt bearbeitet am: 07.01.2024
Beschreibung: Dieser Dart-Code definiert eine Klasse namens Folder. Ein 
Folder-Objekt repräsentiert einen Ordner in der Anwendung und enthält Informationen 
wie die ID des Ordners, den Namen, die Farbe des Ordners und eine Liste von 
Flashcards, die diesem Ordner zugeordnet sind.
*/
import 'package:codecard/widgets/flashcard.dart';
import 'package:flutter/material.dart';

class Folder {
  String id; // Add an ID field
  String name;
  Color color;
  List<Flashcard> flashcards;

  Folder({
    required this.id,
    required this.name,
    required this.color,
    this.flashcards = const [],
  });
}
