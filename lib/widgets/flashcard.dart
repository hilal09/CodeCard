/*
DateiName: flashcard.dart
Authors: Hilal Cubukcu(Flashcard), Arkan Kadir (Flashcard copyWith)
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
  String frontCaption;
  String backCaption;
  Color color;
  int leitnerBox;
  String category; // Added category property

  Flashcard({
    required this.id,
    required this.userUID,
    required this.frontCaption,
    required this.backCaption,
    required this.color,
    required this.leitnerBox,
    required this.category, // Added category parameter to constructor
  });

  Flashcard copyWith({
    String? id,
    String? userUID,
    String? frontCaption,
    String? backCaption,
    Color? color,
    int? leitnerBox,
    String? category, // Added category parameter to copyWith
  }) {
    return Flashcard(
      id: id ?? this.id,
      userUID: userUID ?? this.userUID,
      frontCaption: frontCaption ?? this.frontCaption,
      backCaption: backCaption ?? this.backCaption,
      color: color ?? this.color,
      leitnerBox: leitnerBox ?? this.leitnerBox,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userUID': userUID,
      'frontCaption': frontCaption,
      'backCaption': backCaption,
      'color': color.value, // assuming color is of type Color
      'leitnerBox': leitnerBox,
      'category': category, // Added category to the map
      // Add other properties as needed
    };
  }

  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      userUID: map['userUID'],
      frontCaption: map['frontCaption'],
      backCaption: map['backCaption'],
      color: Color(map['color']),
      leitnerBox: map['leitnerBox'],
      category: map['category'], // Added category property
    );
  }
}
