import '../entities/user_entity.dart';

/// Repository interface for user-related operations.
abstract class UserRepository {
  /// Retrieves user by ID
  Future<UserEntity?> getUserById(String uid);

  /// Authenticates a user with email and password
  Future<UserEntity?> authenticateUser(String email, String password);

  /// Registers a new user with email and password
  Future<UserEntity?> registerUser(String email, String password,
      {String? name, String? phone});

  /// Updates user profile information
  Future<bool> updateUserProfile(UserEntity user);

  /// Updates user profile image
  Future<bool> updateProfileImage(String uid, String imagePath);

  /// Signs out the current user
  Future<void> signOut();
}
