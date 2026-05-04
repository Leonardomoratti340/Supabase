import 'package:flutter/material.dart';
import 'package:flutter_supabase/core/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool isLoading = false;
  Session? session;

  AuthViewModel() {
    session = _authService.currentSession;
  }

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await _authService.signIn(email, password);
      session = response.session;
    } catch (e) {
      print("eroore login $e ");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final respose = await _authService.signUp(email, password);
      session = respose.session;
    } catch (e) {
      print("Errore in registrazione $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    session = null;
    notifyListeners();
  }
}