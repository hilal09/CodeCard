import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:codecard/widgets/left_sidebar.dart';
import 'package:codecard/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthService _authService = AuthService();
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    _authService = AuthService();
    super.initState();
  }


  Future<void> _showDeleteAccountDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bist du Dir sicher?', style: TextStyle(color: Colors.white)),
          content: const Text(
            '''Wenn Du Löschen wählst, löschen wir Dein Konto auf unserem Server.

Deine App-Daten werden ebenfalls gelöscht und Du kannst sie nicht mehr abrufen.''',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(color: Color(0xffffd4a4a)),
              ),
              onPressed: () async {
                // Call the deleteAccount method from AuthService
                await _authService.deleteAccount(currentUser.uid);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const LeftSideBar(),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xffff2c293a),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromARGB(255, 141, 134, 134),
                    width: 0.5,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LabeledEditableTextField(
                        label: 'E-MAIL ADRESSE',
                        initialValue: 'john.doe@example.com',
                        width: 400,
                        onUpdate: _authService.updateEmail,
                      ),
                      const SizedBox(height: 20),
                      LabeledEditableTextField(
                        label: 'PASSWORT',
                        initialValue: '*********',
                        width: 400,
                        onUpdate: _authService.updatePassword,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              _authService.signOut(context);
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Column(
                              children: [
                                Icon(Icons.logout_rounded, color: Colors.white),
                                SizedBox(height: 5),
                                Text('AUSLOGGEN'),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          TextButton(
                            onPressed: () {
                              _showDeleteAccountDialog();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Column(
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
      ),
    );
  }
}

class LabeledEditableTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final double width;
  final Function(String) onUpdate; // Callback function to update the info

  const LabeledEditableTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.width,
    required this.onUpdate, // Pass the callback function
  });

  @override
  _LabeledEditableTextFieldState createState() =>
      _LabeledEditableTextFieldState();
}

class _LabeledEditableTextFieldState extends State<LabeledEditableTextField> {
  late TextEditingController _controller;
  bool _isEditing = false;
  bool _isPasswordVisible = false;

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
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        Container(
          width: widget.width,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(8),
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
                        obscureText:
                            widget.label == 'PASSWORT' && !_isPasswordVisible,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                        decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          border: InputBorder.none,
                        ),
                      )
                    : Text(
                        widget.label == 'PASSWORT'
                            ? _isPasswordVisible
                                ? _controller.text
                                : '•' * _controller.text.length
                            : _controller.text,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.grey),
                      ),
              ),
              if (_isEditing &&
                  widget.label ==
                      'PASSWORT') // Show eye icon only in editing mode for password field
                IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              IconButton(
                icon: Icon(_isEditing ? Icons.done : Icons.edit,
                    color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isEditing = !_isEditing;
                    if (!_isEditing) {
                      // Reset password visibility when editing is done
                      _isPasswordVisible = false;
                      // Invoke the callback to update info in the database
                      widget.onUpdate(_controller.text);
                    }
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
