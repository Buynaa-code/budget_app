import 'dart:math';
import '../models/user.dart';
import 'database_helper.dart';

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
    try {
      // Query the local database for the user with this email
      final db = await DatabaseHelper.instance.database;
      final userMaps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (userMaps.isEmpty) {
        throw Exception('User not found with this email');
      }

      // In a real app, you'd verify the password with a hash
      // For this example, we'll just check if it's our test password
      if (password != 'password') {
        throw Exception('Invalid password');
      }

      final userMap = userMaps.first;
      _currentUser = User(uid: userMap['uid'] as String, email: email);

      return UserCredential(user: _currentUser);
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Register with email and password
  Future<UserCredential> register(String email, String password) async {
    try {
      // Check if user already exists
      final db = await DatabaseHelper.instance.database;
      final existingUser = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (existingUser.isNotEmpty) {
        throw Exception('User with this email already exists');
      }

      // Generate a unique ID
      final uid =
          'user_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';

      // Create the user in the database
      final user = UserModel(
        uid: uid,
        email: email,
        createdAt: DateTime.now(),
      );

      await DatabaseHelper.instance.createUser(user);

      _currentUser = User(uid: uid, email: email);
      return UserCredential(user: _currentUser);
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    _currentUser = null;
  }

  // Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    return await DatabaseHelper.instance.getUser(uid);
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
