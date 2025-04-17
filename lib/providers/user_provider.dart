import 'package:flutter/material.dart';
import 'package:note_mory/models/user.dart';
import 'package:note_mory/services/shared_preferences_service_users.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  final SharedPreferencesServiceUsers _sharedPreferencesServiceUsers =
      SharedPreferencesServiceUsers();

  /// Register the user
  Future<void> registerUser(User newUser) async {
    _user = newUser;
    await _sharedPreferencesServiceUsers.saveUser(newUser);
    notifyListeners();
  }

  /// Update user info
  Future<void> updateUser(
    String username,
    String email,
    String phoneNumber,
    String birth,
    String gender,
    String password,
  ) async {
    _user = User(
      username: username,
      email: email,
      phoneNumber: phoneNumber,
      birth: birth,
      gender: gender,
      password: password,
    );
    notifyListeners();
  }

  ///Login the user
  Future<bool> loginUser(String email, String password) async {
    final allUsers = await _sharedPreferencesServiceUsers.loadAllUsers();

    for (var user in allUsers) {
      if (user.email == email && user.password == password) {
        _user = user;
        await _sharedPreferencesServiceUsers.setLoggedInUser(user.id!);
        notifyListeners();
        return true;
      }
    }

    return false;
  }

  ///Load user
  Future<void> loadUser() async {
    _user = await _sharedPreferencesServiceUsers.loadUser();
    notifyListeners();
  }

  /// Logout user
  Future<void> logoutUser() async {
    _user = null;
    // await _sharedPreferencesServiceUsers.removeUser();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUserId');
    notifyListeners();
  }
}
