import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServiceOnboarding {
  Future<void> setIsLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  Future<bool?> getIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn');
  }

  Future<void> setIsFirstTime(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', value);
  }

  Future<bool?> getIsFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isFirstTime');
  }
}
