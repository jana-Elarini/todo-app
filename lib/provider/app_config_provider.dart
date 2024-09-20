import 'package:flutter/material.dart';

class AppConfigProvider extends ChangeNotifier {
  String appLanguage = 'en';

  ThemeMode appMode = ThemeMode.light;

  Future<void> changeLanguage(String newLanguage) async {
    if (appLanguage == newLanguage) {
      return;
    }
    appLanguage = newLanguage;
    notifyListeners();
  }

  Future<void> changeTheme(ThemeMode newMode) async {
    if (appMode == newMode) {
      return;
    }

    appMode = newMode;
    notifyListeners();
  }

  bool isDrakMode() {
    return appMode == ThemeMode.dark;
  }
}
