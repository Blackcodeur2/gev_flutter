import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('app_locale');
    if (savedLanguageCode != null) {
      _locale = Locale(savedLanguageCode);
    } else {
      _locale = const Locale('en');
    }
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (!['en', 'fr'].contains(locale.languageCode)) return;

    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_locale', locale.languageCode);
    notifyListeners();
  }

  Future<void> clearLocale() async {
    _locale = const Locale('en');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('app_locale');
    notifyListeners();
  }
}
