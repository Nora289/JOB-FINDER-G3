import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String _userName = '';
  String _userEmail = '';
  String _userPhone = '';
  String _userAvatar = '';

  bool get isLoggedIn => _isLoggedIn;

  /// Returns the normalized display name, mapping known condensed names to full names.
  String get userName {
    if (_userName.isEmpty) return _userName;
    final n = _userName.toLowerCase().replaceAll(RegExp(r'\s+'), '');
    return _knownMembers[n] ?? _userName;
  }

  String get userEmail => _userEmail;
  String get userPhone => _userPhone;
  String get userAvatar => _userAvatar;

  /// Known member email prefixes → full display names
  static const Map<String, String> _knownMembers = {
    'soknora': 'Sok Nora',
    'sruochsrean': 'Sruoch Srean',
    'srean': 'Sruoch Srean',
    'unpheasa': 'Un Pheasa',
    'pheasa': 'Un Pheasa',
    'yornsomnang': 'Yorn Somnang',
    'somnang': 'Yorn Somnang',
    'pansothea': 'Pan Sothea',
    'sothea': 'Pan Sothea',
    'nora': 'Sok Nora',
  };

  Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) {
      _isLoggedIn = true;
      final prefix = email.split('@').first.toLowerCase();
      _userName =
          _knownMembers[prefix] ??
          (prefix.isNotEmpty
              ? prefix[0].toUpperCase() + prefix.substring(1)
              : email);
      _userEmail = email;
      _userPhone = '+855 12 345 678';
      _userAvatar = '';
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
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

  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    notifyListeners();
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
