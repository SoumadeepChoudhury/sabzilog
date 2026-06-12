import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_role.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  UserRole? _role;

  User? get user => _user;
  UserRole? get role => _role;

  // Call this after successful login/signup
  void setUser(User? user, UserRole role) {
    _user = user;
    _role = role;
    notifyListeners(); // This tells the UI to update wherever this is used
  }

  // Update user info (like profile picture).. input only parameter.
  Future<void> updateUserProfile(String? profileImageUrl) async {
    if (_user != null) {
      await _user!.updatePhotoURL(profileImageUrl);
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    }
  }

  Future<void> updateName(String name) async {
    if (_user != null) {
      await _user!.updateDisplayName(name);
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    }
  }

  void clearUser() {
    _user = null;
    _role = null;
    notifyListeners();
  }
}
