import 'package:flutter/material.dart';

class Suchleiste extends StatelessWidget {
  final ValueChanged<String> onSearch;

  const Suchleiste({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Wrap the TextField with Container
      width: 200, // Set a specific width
      child: TextField(
        onChanged: onSearch,
        decoration: InputDecoration(
          labelText: 'Search',
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
