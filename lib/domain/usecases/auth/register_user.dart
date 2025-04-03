import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

/// Use case for registering a new user.
class RegisterUser {
  final UserRepository repository;

  RegisterUser(this.repository);

  /// Execute the registration use case with user details.
  Future<UserEntity?> call(String email, String password,
      {String? name, String? phone}) async {
    return await repository.registerUser(email, password,
        name: name, phone: phone);
  }
}
