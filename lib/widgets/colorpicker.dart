import 'package:flutter/material.dart';

class ColorPicker extends StatefulWidget {
  final Function(Color) onColorSelected;
  final Color initialColor;

  const ColorPicker({Key? key, required this.onColorSelected, required this.initialColor})
      : super(key: key);

  @override
  _ColorPickerState createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedColor = widget.initialColor; // Initialize with the provided initial color
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
          widget.onColorSelected(selectedColor); // Notify parent about the selected color
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
        _buildColorButton(const Color(0xffffd4a4a)),
        _buildColorButton(const Color(0xfffe81a81)),
        _buildColorButton(const Color(0xfff94ee6b)),
        _buildColorButton(const Color(0xfff4cae97)),
        _buildColorButton(const Color(0xfffbd64b5)),
      ],
    );
  }
}
