import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final Function(Color) onColorSelected;

  const ColorPicker({super.key, required this.onColorSelected});

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = Color(0xFFFfd4a4a); // Set a default color
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
          widget.onColorSelected(
              selectedColor); // Notify parent about the selected color
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
        _buildColorButton(Color(0xFFFfd4a4a)),
        _buildColorButton(Color(0xFFFe81a81)),
        _buildColorButton(Color(0xFFF94ee6b)),
        _buildColorButton(Color(0xFFF4cae97)),
        _buildColorButton(Color(0xFFFbd64b5)),
      ],
    );
  }
}
