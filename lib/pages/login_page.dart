import 'package:codecard/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:codecard/pages/register_page.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginTab = true;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late AuthService _authService;

  @override
  void initState() {
    _authService = AuthService();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthWidget(
        isLoginTab: isLoginTab,
        onTabChanged: (bool? isSelected) {
          print('onTabChanged - isSelected: $isSelected');
          if (this.mounted) {
            setState(() {
              isLoginTab =
                  isSelected != null ? isSelected : false; // <-- Updated Line
              print('onTabChanged - isLoginTab: $isLoginTab');
            });
          }
        },
        onAuthPressed: () async {
          if (await _authService.signIn(
            context,
            email: emailController.text,
            password: passwordController.text,
          )) {
            // Redirect to DashboardPage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashboardPage()),
            );
          }
        },
        onRegisterPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const RegistrationPage()),
          );
        },
        emailController: emailController,
        passwordController: passwordController,
      ),
    );
  }
}

class AuthWidget extends StatelessWidget {
  final bool isLoginTab;
  final Function(bool) onTabChanged;
  final VoidCallback onAuthPressed;
  final VoidCallback onRegisterPressed;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const AuthWidget({
    Key? key,
    required this.isLoginTab,
    required this.onTabChanged,
    required this.onAuthPressed,
    required this.onRegisterPressed,
    required this.emailController,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffff2c293a),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  const Text(
                    'CODE CARD',
                    style: TextStyle(
                      fontSize: 70,
                      shadows: [
                        Shadow(
                          blurRadius: 6.0,
                          color: Color(0xfff4cae97),
                          offset: Offset(3.0, 1.0),
                        ),
                      ],
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTabButton('Anmelden', true),
                      const SizedBox(width: 50),
                      buildTabButton('Registrieren', false, onRegisterPressed),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'E-Mail Adresse',
                        prefixIcon: const Icon(Icons.mail, color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Passwort',
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                      onPressed: onAuthPressed,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: const Color(0xffff10111a),
                      ),
                      child: const SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            'Bestätigen',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTabButton(String text, bool isSelected,
      [VoidCallback? onPressed]) {
    return ElevatedButton(
      onPressed: () {
        onTabChanged(isSelected);
        if (onPressed != null) {
          onPressed();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isSelected ? const Color(0xffff10111a) : const Color(0xffff2c293a),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white54,
        ),
      ),
    );
  }
}
