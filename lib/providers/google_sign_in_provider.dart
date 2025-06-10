import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:note_mory/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:note_mory/models/user.dart' as users;

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  bool _isSigningIn = false;
  bool get isSigningIn => _isSigningIn;

  Future<bool> googleLogin(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return false;

      _user = googleUser;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Simpan user ke UserProvider lokal
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        final userModel = users.User(
          id: firebaseUser.uid,
          username: firebaseUser.displayName ?? 'Google User',
          email: firebaseUser.email,
          phoneNumber: firebaseUser.phoneNumber ?? '',
          birth: '',
          gender: '',
          password: '',
          isGoogleUser: true,
        );

        await userProvider.registerUser(userModel);
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint("Google login error: $e");
      return false;
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    try {
      // Logout Firebase
      await FirebaseAuth.instance.signOut();

      // Logout dari Google Sign-In
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }

      // Hapus user lokal (SharedPreferences & state)
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.logoutUser();

      notifyListeners();
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }
}
