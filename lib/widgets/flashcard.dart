/* 
DateiName: flashcard.dart
Authors: Hilal Cubukcu(alles, außer id und Box)
Zuletzt bearbeitet am: 07.01.2024
Beschreibung: DDieser Dart-Code definiert eine Klasse namens Flashcard. Ein 
Flashcard-Objekt repräsentiert eine Karte in deiner Anwendung und enthält 
Informationen wie die Benutzer-ID (userUID), die Vorderseitenbeschriftung 
(frontCaption), die Rückseitenbeschriftung (backCaption) und die Farbe der Karte (color).
-`boxNumber`: Ein Schlüsselelement des Leitner-Algorithmus, das die Position der Karteikarte in der Lernbox bestimmt.
Karten bewegen sich zwischen verschiedenen Boxen basierend auf der Korrektheit der Benutzerantworten, 
was ein effizientes Wiederholungsschema ermöglicht.

Diese Klasse ist zentral für die Logik, die Karteikarten in der App betrifft, und unterstützt den Leitner-Algorithmus, um den Lernprozess zu optimieren.

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
