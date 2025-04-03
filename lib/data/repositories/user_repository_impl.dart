import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/user_model.dart';
import 'dart:math';

/// Implementation of the UserRepository interface
class UserRepositoryImpl implements UserRepository {
  final DatabaseHelper _databaseHelper;

  UserRepositoryImpl(this._databaseHelper);

  @override
  Future<UserEntity?> getUserById(String uid) async {
    return await _databaseHelper.getUser(uid);
  }

  @override
  Future<UserEntity?> authenticateUser(String email, String password) async {
    try {
      // Mock authentication for simplicity
      // In a real app, you would implement proper authentication
      final db = await _databaseHelper.database;
      final userMaps = await db.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (userMaps.isEmpty) {
        throw Exception('User not found with this email');
      }

      // In a real app, you'd verify the password with a hash
      // For this example, we'll just check if it's the test password
      if (password != 'password') {
        throw Exception('Invalid password');
      }

      final userMap = userMaps.first;
      return UserModel.fromMap(userMap);
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  @override
  Future<UserEntity?> registerUser(String email, String password,
      {String? name, String? phone}) async {
    try {
      // Check if user already exists
      final db = await _databaseHelper.database;
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

      // Create the user
      final user = UserModel(
        uid: uid,
        email: email,
        name: name,
        phone: phone,
        createdAt: DateTime.now(),
      );

      await _databaseHelper.createUser(user);
      return user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  @override
  Future<bool> updateUserProfile(UserEntity user) async {
    try {
      final userModel = user as UserModel;
      final result = await _databaseHelper.updateUser(userModel);
      return result > 0;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    }
  }

  @override
  Future<bool> updateProfileImage(String uid, String imagePath) async {
    try {
      final userModel = await _databaseHelper.getUser(uid);
      if (userModel != null) {
        final updatedUser = userModel.copyWith(photoUrl: imagePath);
        final result = await _databaseHelper.updateUser(updatedUser);
        return result > 0;
      }
      return false;
    } catch (e) {
      print('Update profile image error: $e');
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    // Nothing to do for simple auth
    // In a real app with remote auth, you'd implement signout logic
  }
}
