import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _userId;
  String? _userEmail;

  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get userId => _userId;
  String? get userEmail => _userEmail;
  User? get user => _authService.currentUser;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    try {
      setLoading(true);
      notifyListeners();

      // TODO: Implement actual authentication
      // For now, using mock implementation
      await Future.delayed(const Duration(seconds: 2));

      if (email == "test@example.com" && password == "password") {
        _isAuthenticated = true;
        _userId = "user123";
        _userEmail = email;
      } else {
        throw Exception("Invalid credentials");
      }
    } catch (e) {
      _isAuthenticated = false;
      _userId = null;
      _userEmail = null;
      rethrow;
    } finally {
      setLoading(false);
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, String? name) async {
    setLoading(true);
    try {
      UserCredential userCredential =
          await _authService.register(email, password);
      if (userCredential.user != null) {
        _userModel = UserModel(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email ?? '',
          name: name,
        );

        // Save user data
        await DatabaseService(uid: userCredential.user!.uid).saveUserData(
          userCredential.user!.email ?? '',
          name,
        );
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> signOut() async {
    setLoading(true);
    try {
      await _authService.signOut();
      _userModel = null;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  void logout() {
    _isAuthenticated = false;
    _userId = null;
    _userEmail = null;
    notifyListeners();
  }
}
