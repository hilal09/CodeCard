import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importiere das Package für InputFormatters

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
      width: 355,
      height: 30,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 45, 31, 65),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: Colors.white),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: widget.onSearch,
              focusNode: _focusNode,
              inputFormatters: [
                LengthLimitingTextInputFormatter(25), // Begrenze auf 25 Zeichen
              ],
              style: TextStyle(fontSize: 17, color: Colors.white),
              decoration: InputDecoration(
                labelText: _hasFocus ? '' : 'Suche',
                labelStyle: TextStyle(fontSize: 20, color: Colors.white),
                fillColor: Color.fromARGB(255, 45, 31, 65),
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
