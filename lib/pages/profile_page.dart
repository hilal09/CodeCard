import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
            width: 70,
            decoration: BoxDecoration(
              color: Color(0xFFFF2c293a),
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Color.fromARGB(255, 141, 134, 134),
                width: 0.5,
              ), // White border
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    'assets/images/Logo.png',
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                IconButton(
                  icon: Icon(Icons.home_rounded, color: Colors.white),
                  onPressed: () {
                    // Action when clicking the Home Icon
                  },
                ),
                SizedBox(height: 10),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    // Action when clicking the Add Icon
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ), // Adds spacing between the container and the rest of the page
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFF2c293a),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color.fromARGB(255, 141, 134, 134),
                  width: 0.5,
                ), // White border
              ),
              padding: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LabeledEditableTextField(
                      label: 'E-MAIL ADRESSE',
                      initialValue: 'john.doe@example.com',
                      width: 400, // Adjust the width as needed
                    ),
                    SizedBox(height: 20),
                    LabeledEditableTextField(
                      label: 'PASSWORT',
                      initialValue: '*********',
                      width: 400, // Adjust the width as needed
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            // Action when clicking the Logout button
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.logout_rounded, color: Colors.white),
                              SizedBox(height: 5),
                              Text('AUSLOGGEN'),
                            ],
                          ),
                        ),
                        SizedBox(width: 20), // Add spacing between buttons
                        TextButton(
                          onPressed: () {
                            // Action when clicking the Delete button
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.delete_forever_rounded,
                                  color: Colors.white),
                              SizedBox(height: 5),
                              Text('ACCOUNT LÖSCHEN'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LabeledEditableTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final double width;

  LabeledEditableTextField({
    required this.label,
    required this.initialValue,
    required this.width,
  });

  @override
  _LabeledEditableTextFieldState createState() =>
      _LabeledEditableTextFieldState();
}

class _LabeledEditableTextFieldState extends State<LabeledEditableTextField> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        Container(
          width: widget.width,
          margin: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _isEditing
                    ? TextField(
                        controller: _controller,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: InputBorder.none,
                        ),
                      )
                    : Text(
                        _controller.text,
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
              ),
              IconButton(
                icon: Icon(_isEditing ? Icons.done : Icons.edit,
                    color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
