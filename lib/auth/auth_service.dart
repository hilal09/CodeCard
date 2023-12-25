import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  late SupabaseClient client;

  AuthService() {
    client = Supabase.instance.client;
  }

  bool isLoggedIn() {
    try {
      return client.auth.currentSession != null;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  Future<void> signUpUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse res = await client.auth.signUp(
        password: password,
        email: email,
      );
      final Session? session = res.session;

      if (session == null) {
        print('Sign-up successful');
      } else {
        print('Sign-up failed: ${session}');
      }
    } catch (e) {
      print('Error during sign-up: $e');
    }
  }

  Future<void> logInUsingEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final AuthResponse res = await client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      final Session? session = res.session;

      if (session == null) {
        print('Sign-in successful');
      } else {
        print('Sign-in failed: ${session}');
      }
    } catch (e) {
      print('Error during sign-in: $e');
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }
}
