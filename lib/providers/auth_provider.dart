import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = userCredential.user;
      await refreshUserData();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register(
      String email, String password, String name, String phone) async {
    try {
      _isLoading = true;
      notifyListeners();

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = userCredential.user;
      if (_user != null) {
        _userModel = UserModel(
          uid: _user!.uid,
          email: email,
          name: name,
          phone: phone,
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    _userModel = null;
    notifyListeners();
  }

  Future<void> refreshUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      // TODO: Fetch user data from database
      _userModel = UserModel(
        uid: _user!.uid,
        email: _user!.email ?? '',
      );
    }
    notifyListeners();
  }

  Future<bool> updateProfileImage(String imagePath) async {
    try {
      // TODO: Implement profile image update
      return true;
    } catch (e) {
      return false;
    }
  }
}
