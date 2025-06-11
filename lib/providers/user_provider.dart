import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
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
    await registerUserFromFirebase(newUser);
    notifyListeners();
  }

  Future<void> registerUserFromFirebase(User user) async {
    try {
      // Register ke Firebase Auth
      auth.UserCredential credential =
          await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      // Update ID user dari hasil credential
      user.id = credential.user!.uid;

      // Simpan data user ke Firestore
      await FirebaseFirestore.instance.collection('users').doc(user.id).set({
        'id': user.id,
        'username': user.username,
        'email': user.email,
        'phoneNumber': user.phoneNumber,
        'birth': user.birth,
        'gender': user.gender,
        'isGoogleUser': user.isGoogleUser ?? false,
      });

      print("Registrasi berhasil dan aman");
    } catch (e) {
      print("Gagal registrasi: $e");
    }
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
        print("${user.email} dan ${user.password} loginUser provider");
        _user = user;
        await _sharedPreferencesServiceUsers.setLoggedInUser(user.id!);
        notifyListeners();
        return true;
      }
    }

    try {
      // Login pakai Firebase Auth
      final credential = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Ambil UID
      final uid = credential.user!.uid;

      // Ambil data user dari Firestore
      final userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        _user = User(
          id: uid,
          username: data['username'],
          email: data['email'],
          phoneNumber: data['phoneNumber'],
          birth: data['birth'],
          gender: data['gender'],
          password: '',
        );

        notifyListeners();
        return true;
      }

      return false; // Data user tidak ditemukan di Firestore
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  ///Load user
  Future<void> loadUser() async {
    final currentUser = auth.FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data()!;
        _user = User(
          id: currentUser.uid,
          username: data['username'],
          email: data['email'],
          phoneNumber: data['phoneNumber'],
          birth: data['birth'],
          gender: data['gender'],
          password: '',
        );

        notifyListeners();
      }
    }

    _user = await _sharedPreferencesServiceUsers.loadUser();
    notifyListeners();
  }

  /// Logout user
  Future<void> logoutUser() async {
    _user = null;
    // await _sharedPreferencesServiceUsers.removeUser();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUserId');
    await auth.FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
