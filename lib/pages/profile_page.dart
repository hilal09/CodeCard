import 'package:flutter/material.dart';
import 'package:codecard/widgets/left_sidebar.dart';
import 'login_page.dart';
import 'package:codecard/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthService _authService;

  @override
  void initState() {
    _authService = AuthService();
    super.initState();
  }

  // Callback function to update email in the database
  void updateEmail(String newEmail) {
    // Implement your logic to update email in the database
    print('Updating email: $newEmail');
  }

  // Callback function to update password in the database
  void updatePassword(String newPassword) {
    // Implement your logic to update password in the database
    print('Updating password: $newPassword');
  }

  void logout() {
    _authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void deleteAccount() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            LeftSideBar(),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFF2c293a),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Color.fromARGB(255, 141, 134, 134),
                    width: 0.5,
                  ),
                ),
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LabeledEditableTextField(
                        label: 'E-MAIL ADRESSE',
                        initialValue: 'john.doe@example.com',
                        width: 400,
                        onUpdate: updateEmail,
                      ),
                      SizedBox(height: 20),
                      LabeledEditableTextField(
                        label: 'PASSWORT',
                        initialValue: '*********',
                        width: 400,
                        onUpdate: updatePassword,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              logout();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
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
                          SizedBox(width: 20),
                          TextButton(
                            onPressed: () {
                              deleteAccount();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
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
      ),
    );
  }
}

class LabeledEditableTextField extends StatefulWidget {
  final String label;
  final String initialValue;
  final double width;
  final Function(String) onUpdate; // Callback function to update the info

  LabeledEditableTextField({
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
                        obscureText:
                            widget.label == 'PASSWORT' && !_isPasswordVisible,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                        decoration: InputDecoration(
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
                        style: TextStyle(fontSize: 18, color: Colors.grey),
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
