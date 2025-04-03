import 'package:get_it/get_it.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/usecases/profile/update_profile.dart';
import '../domain/usecases/profile/update_profile_image.dart';

/// Register profile-related dependencies
Future<void> profileInjection(GetIt sl) async {
  // Use cases
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfileImage(sl()));

  // Note: UserRepository is already registered in auth_injection.dart
}
