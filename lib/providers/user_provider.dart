import 'package:flutter/material.dart';
import 'package:note_mory/models/user.dart';

class UserProvider with ChangeNotifier {
  User? _user;

  User? get user => _user;

  /// Register the user
  void registerUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  /// Update user info
  void updateUser(
    String username,
    String email,
    String phoneNumber,
    String birth,
    String gender,
    String password,
  ) {
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
  bool loginUser(String email, String password) {
    if (_user != null && _user!.email == email && _user!.password == password) {
      return true;
    }
    return false;
  }

  /// Logout user
  void logoutUser() {
    _user = User(
      username: '',
      email: '',
      phoneNumber: '',
      birth: '',
      gender: '',
      password: '',
    );
    notifyListeners();
  }
}
