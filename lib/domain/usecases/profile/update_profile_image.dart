import '../../repositories/user_repository.dart';

/// Use case for updating a user's profile image.
class UpdateProfileImage {
  final UserRepository repository;

  UpdateProfileImage(this.repository);

  /// Execute the profile image update use case with user ID and image path.
  Future<bool> call(String uid, String imagePath) async {
    return await repository.updateProfileImage(uid, imagePath);
  }
}
