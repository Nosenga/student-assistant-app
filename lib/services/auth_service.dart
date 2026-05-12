import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      rethrow;
    }
  }

  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  Future<String?> getUserRole(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select('role')
          .eq('id', userId)
          .single();
          

      return response['role'] as String?;
    } catch (e) {
      return 'student';
    }
  }
}