import 'package:flutter/material.dart';
import 'package:mylab_go/l10n/l10n.dart'; // This gives us supported locales

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('ur'); // Default language set to Urdu

  Locale get locale => _locale;

  void toggleLocale() {
    // Toggle between Urdu and English
    if (_locale.languageCode == 'ur') {
      _locale = const Locale('en'); // Switch to English
    } else {
      _locale = const Locale('ur'); // Switch to Urdu
    }
    notifyListeners(); // Notify listeners to rebuild the UI
  }

  void setLocale(Locale locale) {
    if (!L10n.supportedLocales.contains(locale)) return;
    _locale = locale;
    notifyListeners(); // Tells Flutter to rebuild with new locale
  }

  void clearLocale() {
    _locale = const Locale('ur'); // Reset to default (Urdu)
    notifyListeners();
  }
}
// This class manages the locale state and notifies listeners when it changes.