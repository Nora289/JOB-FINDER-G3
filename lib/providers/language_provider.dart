import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  String _languageCode = 'en'; // 'en' or 'km'

  String get languageCode => _languageCode;
  bool get isKhmer => _languageCode == 'km';

  Locale get locale => Locale(_languageCode);

  void setLanguage(String code) {
    if (_languageCode == code) return;
    _languageCode = code;
    notifyListeners();
  }
}
