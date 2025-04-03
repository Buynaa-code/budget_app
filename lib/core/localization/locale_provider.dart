import 'package:flutter/material.dart';

/// Provider for managing application locale
class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  /// Get the current locale
  Locale get locale => _locale;

  /// Set a new locale and notify listeners
  void setLocale(Locale locale) {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
    }
  }
}
