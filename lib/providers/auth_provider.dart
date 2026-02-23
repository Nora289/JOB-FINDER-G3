import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  String _userAvatar = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userAvatar => _userAvatar;

  Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _userName = 'Sokha Chan';
      _userEmail = email;
      _userPhone = '+855 12 345 678';
      _userAvatar = '';
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      _userName = name;
      _userEmail = email;
      _userPhone = phone;
      _userAvatar = '';
      notifyListeners();
      return true;
    }
    return false;
  }

  void signOut() {
    _isLoggedIn = false;
    _userName = '';
    _userEmail = '';
    _userPhone = '';
    _userAvatar = '';
    notifyListeners();
  }
}
