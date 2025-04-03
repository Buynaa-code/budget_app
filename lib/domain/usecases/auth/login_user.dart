import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

/// Use case for logging in a user.
class LoginUser {
  final UserRepository repository;

  LoginUser(this.repository);

  /// Execute the login use case with email and password.
  Future<UserEntity?> call(String email, String password) async {
    return await repository.authenticateUser(email, password);
  }
}
