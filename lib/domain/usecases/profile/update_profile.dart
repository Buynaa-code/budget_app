import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

/// Use case for updating a user's profile information.
class UpdateProfile {
  final UserRepository repository;

  UpdateProfile(this.repository);

  /// Execute the profile update use case with user entity.
  Future<bool> call(UserEntity user) async {
    return await repository.updateUserProfile(user);
  }
}
