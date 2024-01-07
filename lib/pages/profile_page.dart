import 'package:codecard/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:codecard/widgets/left_sidebar.dart';
import 'package:codecard/auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthService _authService = AuthService();
  final currentUser = FirebaseAuth.instance.currentUser!;
  final _currentPasswordController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _passwordsMatch = true;

  @override
  void initState() {
    _authService = AuthService();
    super.initState();
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
                      labeledEditableTextField(
                        label: 'E-MAIL ADRESSE',
                        initialValue: currentUser.email ?? '',
                        width: 400,
                        onEditClick: () {
                          showUpdateEmailDialog();
                        },
                      ),
                      const SizedBox(height: 20),
                      labeledEditableTextField(
                        label: 'PASSWORT',
                        initialValue: '*********',
                        width: 400,
                        onEditClick: () {
                          _showChangePasswordDialog();
                        },
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

  Future<void> _showDeleteAccountDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Bist du Dir sicher?',
              style: TextStyle(color: Colors.white)),
          content: const Text(
            '''Wenn Du Löschen wählst, löschen wir Dein Konto auf unserem Server.

Deine App-Daten werden ebenfalls gelöscht und Du kannst sie nicht mehr abrufen.''',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Löschen',
                style: TextStyle(color: Color(0xffffd4a4a)),
              ),
              onPressed: () async {
                // Call the deleteAccount method from AuthService
                await _authService.deleteAccount(currentUser.uid);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> updateEmail(String currentPassword, String newEmail) async {
    User user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!, password: currentPassword);

    Map<String, String?> codeResponses = {
      "user-mismatch": null,
      "invalid-credential": null,
      "invalid-email": null,
      "invalid-verification-code": null,
      "invalid-verification-id": null,
      "weak-password": null,
      "requires-recent-login": null,
      //die beiden funktionieren nicht wegen einer neuen email enumeration Regel seit September 23
      "user-not-found": null,
      "wrong-password": null,
    };

    try {
      await user.reauthenticateWithCredential(credential);
      await currentUser.verifyBeforeUpdateEmail(newEmail);
      await _authService.signOut(context);
      ;
    } on FirebaseAuthException catch (error) {
      _showErrorPopup(error.toString());
    }
  }

  Future<String?> updatePassword(String oldPassword, String newPassword) async {
    User user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential =
        EmailAuthProvider.credential(email: user.email!, password: oldPassword);

    Map<String, String?> codeResponses = {
      "user-mismatch": null,
      "user-not-found": null,
      "invalid-credential": null,
      "invalid-email": null,
      "wrong-password": null,
      "invalid-verification-code": null,
      "invalid-verification-id": null,
      "weak-password": null,
      "requires-recent-login": null
    };

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      await _authService.signOut(context);
    } on FirebaseAuthException catch (error) {
      String errorMessage =
          codeResponses[error.code] ?? "Wrong current password";
      _showErrorPopup(errorMessage);
    }
  }

  void _showErrorPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK', style: TextStyle(color: Color(0xFFFF7A00))),
            ),
          ],
        );
      },
    );
  }

  void showUpdateEmailDialog() {
    final TextEditingController currentPasswordController =
        TextEditingController();
    final TextEditingController newEmailController = TextEditingController();
    bool showError = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Current Password'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: newEmailController,
                decoration: InputDecoration(labelText: 'New Email'),
              ),
              if (showError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Please fill in both fields',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Attention: You need to verify your new email before you can log in again.',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Add your logic to handle updating email
                String currentPassword = currentPasswordController.text;
                String newEmail = newEmailController.text;

                // Validate fields and perform the update
                if (currentPassword.isNotEmpty && newEmail.isNotEmpty) {
                  // Call your update email function or perform the desired action
                  updateEmail(currentPassword, newEmail);
                  Navigator.of(context)
                      .pop(); // Close the dialog using the captured context
                } else {
                  // Show error message
                  setState(() {
                    showError = true;
                  });
                }
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: _currentPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Current password',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xfffbd64b5)),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'You need to type in your current password';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'New Password',
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xfffbd64b5)),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'You need to type in a password';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      errorText:
                          _passwordsMatch ? null : 'Passwords do not match',
                      errorStyle: TextStyle(color: Colors.red),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xfffbd64b5)),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (_passwordController.text.isNotEmpty &&
                          value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearTextFields();
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  updatePassword(_currentPasswordController.text,
                      _passwordController.text);
                  Navigator.of(context).pop();
                  _clearTextFields();
                }
              },
              child: Text('Save', style: TextStyle(color: Color(0xfff94ee6b))),
            ),
          ],
        );
      },
    );
  }

  void _clearTextFields() {
    _currentPasswordController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  Widget labeledEditableTextField({
    required String label,
    required String initialValue,
    required double width,
    VoidCallback? onEditClick, // Callback function for edit icon click
  }) {
    late TextEditingController _controller;
    String _editingValue = initialValue;

    _controller = TextEditingController(text: initialValue);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        Container(
          width: width,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: AbsorbPointer(
                    absorbing: true,
                    child: TextField(
                      controller: _controller,
                      readOnly: true,
                      obscureText: label == 'PASSWORT',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      decoration: const InputDecoration(
                        isCollapsed: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        border: InputBorder.none,
                      ),
                      onChanged: (value) {
                        _editingValue = value;
                      },
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  onEditClick != null ? Icons.edit : null,
                  color: Colors.white,
                ),
                onPressed: onEditClick,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
