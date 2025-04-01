import '../models/user.dart';

// Mock User class to replace Firebase User
class User {
  final String uid;
  final String? email;

  User({required this.uid, this.email});
}

// Mock UserCredential class to replace Firebase UserCredential
class UserCredential {
  final User? user;

  UserCredential({this.user});
}

class AuthService {
  // Mock authentication state
  User? _currentUser;

  // Get current user
  User? get currentUser => _currentUser;

  // Sign in with email and password
  Future<UserCredential> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    if (email == 'test@example.com' && password == 'password') {
      _currentUser = User(uid: '123456', email: email);
      return UserCredential(user: _currentUser);
    } else {
      throw Exception('Invalid email or password');
    }
  }

  // Register with email and password
  Future<UserCredential> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    _currentUser = User(
        uid: 'user_${DateTime.now().millisecondsSinceEpoch}', email: email);
    return UserCredential(user: _currentUser);
  }

  // Sign out
  Future<void> signOut() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    _currentUser = null;
  }

  // Convert User to UserModel
  UserModel? userFromUser(User? user) {
    return user != null
        ? UserModel(
            uid: user.uid,
            email: user.email ?? '',
          )
        : null;
  }
}
