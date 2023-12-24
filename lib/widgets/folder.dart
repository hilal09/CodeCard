import 'package:codecard/widgets/flashcard.dart';
import 'package:flutter/material.dart';

class Folder {
  String name;
  Color color;
  List<Flashcard> flashcards;

  Folder({
    required this.name,
    required this.color,
    this.flashcards = const [],
  });
}
