import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_assistant_app/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> logIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authService.signIn(email, password);
       if(response.user != null) {
        _isLoading = false;
        notifyListeners();
        return true;
       }

       _isLoading = false;
       notifyListeners();
       return false;
    } catch (e) {
      _errorMessage = _getFriendlyErrorMessage( e.toString());
      _isLoading = false;
      notifyListeners();
      return false; 
    }
  }

  Future<void> logOut() async {
    await _authService.signOut();
    notifyListeners();
  }

  
  Future<String?> getUserRole(String userId) async {
    return await _authService.getUserRole(userId);
  }

  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }


  String _getFriendlyErrorMessage(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Incorrect email or password. Please try again.';
    }
    if(error.contains('Email not confirmed')) {
      return 'Email not confirmed. Please check your inbox and click the confirmation link.';
    }
    return 'Login failed. Please try again.';
  }
}