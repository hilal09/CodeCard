import 'package:flutter/material.dart';

class Suchleiste extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const Suchleiste({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SuchleisteState createState() => _SuchleisteState();
}

class _SuchleisteState extends State<Suchleiste> {
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 355, // Set a specific width
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 45, 31, 65), // Graue Hintergrundfarbe
        borderRadius: BorderRadius.circular(20), // Runde Ecken
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white), // Weiß für das Lupensymbol
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: widget.onSearch,
              focusNode: _focusNode,
              style: TextStyle(fontSize: 17, color: Colors.white), // Schriftgröße erhöhen und weiß machen
              decoration: InputDecoration(
                labelText: _hasFocus ? '' : 'Search', // Leer, wenn fokussiert, sonst 'Search'
                labelStyle: TextStyle(fontSize: 20, color: Colors.white), // Schriftgröße und Farbe für Label
                fillColor: Color.fromARGB(255, 45, 31, 65),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10), // Höhe reduzieren
                border: InputBorder.none, // Remove border
              ),
            ),
          ),
        ],
      ),
    );
  }
}
