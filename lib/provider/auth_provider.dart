import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_services.dart';

class AuthProviders with ChangeNotifier {
  final AuthServices _authServices = AuthServices();
  User? _user;
  bool _isLoggedIn = false;

  User? get user => _user;

  AuthProviders() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _user = FirebaseAuth.instance.currentUser;
    _isLoggedIn = _user != null;
    notifyListeners();
  }

  Future<void> loginWithGoogle() async {
    _user = await _authServices.signInWithGoogle();
    if (_user != null) {
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authServices.signOut();
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
