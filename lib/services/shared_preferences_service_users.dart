import 'dart:convert';
import 'package:note_mory/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesServiceUsers {
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    // Ambil daftar user sebelumnya
    List<String> userList = prefs.getStringList('users') ?? [];

    // Cek apakah user dengan email sama sudah ada
    bool userExists = userList.any((userStr) {
      final existingUser = User.fromMap(json.decode(userStr));
      return existingUser.email == user.email;
    });

    if (!userExists) {
      userList.add(json.encode(user.toMap()));
      await prefs.setStringList('users', userList);
    }
  }

  Future<List<User>> loadAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> userList = prefs.getStringList('users') ?? [];
    return userList.map((str) => User.fromMap(json.decode(str))).toList();
  }

  Future<void> setLoggedInUser(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('loggedInUserId', userId);
  }

  Future<String?> getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('loggedInUserId');
  }

  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('loggedInUserId');

    if (userId != null) {
      final userList = prefs.getStringList('users') ?? [];

      for (var userStr in userList) {
        final userMap = json.decode(userStr);
        if (userMap['id'] == userId) {
          return User.fromMap(userMap);
        }
      }
    }

    return null;
  }

  Future<void> removeUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
