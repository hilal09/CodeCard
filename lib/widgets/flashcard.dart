/* 
DateiName: flashcard.dart
Authors: Hilal Cubukcu(alles, außer id)
Zuletzt bearbeitet am: 07.01.2024
Beschreibung: DDieser Dart-Code definiert eine Klasse namens Flashcard. Ein 
Flashcard-Objekt repräsentiert eine Karte in deiner Anwendung und enthält 
Informationen wie die Benutzer-ID (userUID), die Vorderseitenbeschriftung 
(frontCaption), die Rückseitenbeschriftung (backCaption) und die Farbe der Karte (color).
*/
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
