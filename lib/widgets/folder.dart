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