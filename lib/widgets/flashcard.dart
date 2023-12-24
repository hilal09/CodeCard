import 'package:flutter/material.dart';

class Flashcard {
  late String frontCaption;
  late String backCaption;
  late Color color;

  Flashcard({
    required this.frontCaption,
    required this.backCaption,
    required this.color,
  });
}
