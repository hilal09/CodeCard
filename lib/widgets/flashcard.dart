/* 
DateiName: flashcard.dart
Authors: Hilal Cubukcu(alles, außer id)
Zuletzt bearbeitet am: 07.01.2024
Beschreibung: Dieser Dart-Code definiert eine Klasse namens Flashcard. Ein
Flashcard-Objekt repräsentiert eine Karte in deiner Anwendung und enthält
Informationen wie die Benutzer-ID (userUID), die Vorderseitenbeschriftung
(frontCaption), die Rückseitenbeschriftung (backCaption) und die Farbe der Karte (color).
-`boxNumber`: Ein Schlüsselelement des Leitner-Algorithmus, das die Position der Karteikarte in der Lernbox bestimmt.
Karten bewegen sich zwischen verschiedenen Boxen basierend auf der Korrektheit der Benutzerantworten,
was ein effizientes Wiederholungsschema ermöglicht.

Diese Klasse ist zentral für die Logik, die Karteikarten in der App betrifft, und unterstützt den Leitner-Algorithmus, um den Lernprozess zu optimieren.

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

CollectionReference flashcards = FirebaseFirestore.instance.collection('flashcards');

class Flashcard {
  final String id;
  final String userUID;
  late String frontCaption;
  late String backCaption;
  late Color color;
  int leitnerBox;

  Flashcard({
    required this.id,
    required this.userUID,
    required this.frontCaption,
    required this.backCaption,
    required this.color,
    required this.leitnerBox,
  });

  Flashcard copyWith({
    String? id,
    String? userUID,
    String? frontCaption,
    String? backCaption,
    Color? color,
    int? leitnerBox,
  }) {
    return Flashcard(
      id: id ?? this.id,
      userUID: userUID ?? this.userUID,
      frontCaption: frontCaption ?? this.frontCaption,
      backCaption: backCaption ?? this.backCaption,
      color: color ?? this.color,
      leitnerBox: leitnerBox ?? this.leitnerBox,
    );
  }
}
