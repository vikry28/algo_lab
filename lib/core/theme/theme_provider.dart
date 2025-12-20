import 'package:flutter/material.dart';
import '../config/prefs.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDark = false;
  Locale _locale = const Locale('en');

  bool get isDark => _isDark;
  Locale get locale => _locale;

  ThemeProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final isDarkPref = Prefs.getBool('isDark', defaultValue: false);
    final langCode = Prefs.getString('locale', defaultValue: 'en');

    _isDark = isDarkPref;
    _locale = Locale(langCode);
    notifyListeners();
  }

  void toggleTheme() {
    _isDark = !_isDark;
    Prefs.setBool('isDark', _isDark);
    notifyListeners();
  }

  void toggleLocale() => setLocale(
    _locale.languageCode == 'id' ? const Locale('en') : const Locale('id'),
  );

  void setLocale(Locale newLocale) {
    _locale = newLocale;
    Prefs.setString('locale', newLocale.languageCode);
    notifyListeners();
  }
}
