import 'package:flutter/material.dart';

class Flashcard {
  final String userUID;
  late final String frontCaption;
  late final String backCaption;
  late final Color color;

  Flashcard({
    required this.userUID,
    required this.frontCaption,
    required this.backCaption,
    required this.color,
  });
}
