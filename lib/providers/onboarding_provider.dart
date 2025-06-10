import 'package:flutter/material.dart';
import 'package:note_mory/services/shared_preferences_service_onboarding.dart';

class OnboardingProvider with ChangeNotifier {
  final SharedPreferencesServiceOnboarding _prefsService =
      SharedPreferencesServiceOnboarding();

  bool _isLoggedIn = false;
  bool _isFirstTime = true;

  bool get isLoggedIn => _isLoggedIn;
  bool get isFirstTime => _isFirstTime;

  OnboardingProvider() {
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    _isLoggedIn = await _prefsService.getIsLoggedIn() ?? false;
    _isFirstTime = await _prefsService.getIsFirstTime() ?? true;
    notifyListeners();
  }

  Future<void> setLoggedIn(bool value) async {
    _isLoggedIn = value;
    await _prefsService.setIsLoggedIn(value);
    notifyListeners();
  }

  Future<void> setFirstTime(bool value) async {
    _isFirstTime = value;
    await _prefsService.setIsFirstTime(value);
    notifyListeners();
  }
}
