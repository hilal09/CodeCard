/* 
DateiName: colorpicker.dart
Authors: Hilal Cubukcu(alles)
Zuletzt bearbeitet am: 07.01.2024
Beschreibung: Dieser Flutter-Code implementiert einen einfachen Farbauswähler 
(ColorPicker). Der Farbauswähler besteht aus verschiedenen Farbauswahl-Buttons, 
die der Benutzer antippen kann. Die ausgewählte Farbe wird visuell durch ein 
Häkchen in dem ausgewählten Farbbutton dargestellt. Der Farbauswähler gibt die 
ausgewählte Farbe über die bereitgestellte Funktion onColorSelected zurück und 
akzeptiert eine optionale anfängliche Farbe (initialColor).
*/

import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final Function(Color) onColorSelected;
  final Color initialColor;

  const ColorPicker(
      {Key? key, required this.onColorSelected, required this.initialColor})
      : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor;
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
          widget.onColorSelected(selectedColor);
        });
      },
      child: Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: selectedColor == color
            ? const Icon(Icons.check, color: Colors.white)
            : const SizedBox(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        _buildColorButton(const Color(0xfffe69597)),
        _buildColorButton(const Color(0xfffceb5b7)),
        _buildColorButton(const Color(0xfff9cadce)),
        _buildColorButton(const Color(0xfff7ec4cf)),
        _buildColorButton(const Color(0xfff84dcc6)),
      ],
    );
  }
}
