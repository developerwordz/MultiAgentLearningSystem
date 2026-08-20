import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserProfile? _user;
  bool _isLoading = false;
  String? _error;

  UserProfile? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  final supabase = Supabase.instance.client;

  // Initialize auth state on app start
  Future<void> checkAuthState() async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      _user = UserProfile(
        id: session.user.id,
        email: session.user.email ?? '',
        createdAt: DateTime.now(),
      );
    }
    notifyListeners();
  }

  // Sign up
  Future<void> signup(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = UserProfile(
          id: response.user!.id,
          email: response.user!.email ?? '',
          createdAt: DateTime.now(),
        );
        _error = null;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
 Future<void> signInWithGoogle() async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
    );
  } catch (e) {
    _error = e.toString();
  }

  _isLoading = false;
  notifyListeners();
}
  // Login
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = UserProfile(
          id: response.user!.id,
          email: response.user!.email ?? '',
          createdAt: DateTime.now(),
        );
        _error = null;
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await supabase.auth.signOut();
      _user = null;
      _error = null;
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}