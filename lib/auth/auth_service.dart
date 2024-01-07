import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codecard/pages/dashboard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/login_page.dart';
import '../widgets/flashcard.dart';
import '../widgets/folder.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  VoidCallback? _setStateCallback;

  String emailError = "";
  String passwordError = "";
  String confirmPasswordError = "";

  AuthService();

  void setState(VoidCallback fn) {
    _setStateCallback = fn;
    _setStateCallback?.call();
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  bool passwordConfirmed() {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      setState(() {
        confirmPasswordError = "Passwords don't match!";
      });
      return false;
    }
    return true;
  }

  String? currentUserUID() {
    try {
      return _auth.currentUser?.uid;
    } catch (e) {
      print('Error getting current user UID: $e');
      return null;
    }
  }

  bool isLoggedIn() {
    try {
      return _auth.currentUser != null;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Register Function
  Future signUp(
      BuildContext context, _emailController, _passwordControlle) async {
    setState(() {
      emailError = "";
      passwordError = "";
      confirmPasswordError = "";
    });

    if (_emailController.text.trim().isEmpty) {
      setState(() {
        emailError = "E-Mail address is necessary";
      });
      showSnackBar(context, "E-Mail address is necessary");
      return;
    }

    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        passwordError = "Password is necessary";
      });
      showSnackBar(context, "Password is necessary");
      return;
    }

    if (!passwordConfirmed()) {
      showSnackBar(context, "Passwords don't match!");
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await addUserDetailsWithFolders(
        _emailController.text.trim(),
        _auth.currentUser!.uid,
      );

      showSnackBar(
        context,
        "Registration successful. Please check your email for verification.",
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } catch (e) {
      showSnackBar(context, "Registration failed: $e");
    }
  }

  Future signIn(BuildContext context,
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => DashboardPage()),
          (route) => false,
        );
      } else {
        print("Login error: not verified yet.");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Please verify your email before logging in.'),
            );
          },
        );
      }
    } catch (e) {
      print("Login error: $e");
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text("Login failed: $e"),
          );
        },
      );
    }
  }

  //Profile Function
  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage()),
      (route) => false,
    );
  }

  //Add User Details to Database
  Future<void> addUserDetails(String email, String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "E-Mail": email,
      "userUID": uid,
    });
  }

  Future<void> addUserDetailsWithFolders(String email, String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).set({
      "E-Mail": email,
      "userUID": uid,
    });

    // Create an initial 'folders' collection for the user
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("folders")
        .add({
      "name": "Default Folder",
      "color": 0xFFFFD4A4A,
      "userUID": uid,
    });
  }

  //Add Folder to UserUID
  Future<void> addFolderToUser(String uid, Folder folder) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('folders')
          .add({
        'name': folder.name,
        'color': folder.color.value,
        "userUID": uid,
      });
    } catch (e) {
      print('Error adding folder to user: $e');
    }
  }

  //Add Flashcards to Folders
  Future<void> addFlashcardToUser(
      String uid, String folderId, Flashcard flashcard) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('folders')
          .doc(folderId)
          .collection('flashcards')
          .add({
        'frontCaption': flashcard.frontCaption,
        'backCaption': flashcard.backCaption,
        'color': flashcard.color.value,
        "userUID": uid,
      });
    } catch (e) {
      print('Error adding flashcard to user: $e');
    }
  }

  Future<List<Flashcard>> getUserFlashcards(String folderId) async {
    try {
      String userId = currentUserUID()!;

      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .collection('folders')
          .doc(folderId)
          .collection('flashcards')
          .get();

      List<Flashcard> userFlashcards =
          snapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        Map<String, dynamic> data = doc.data()!;
        return Flashcard(
          userUID: data['userUID'], // Include userUID in the Flashcard model
          frontCaption: data['frontCaption'],
          backCaption: data['backCaption'],
          color: Color(data['color']),
        );
      }).toList();

      return userFlashcards;
    } catch (e) {
      print("Error fetching user flashcards: $e");
      throw e; // Propagate the error
    }
  }
}
