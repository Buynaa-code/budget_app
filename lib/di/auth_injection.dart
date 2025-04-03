import 'package:get_it/get_it.dart';
import '../data/datasources/local/database_helper.dart';
import '../data/repositories/user_repository_impl.dart';
import '../domain/repositories/user_repository.dart';
import '../domain/usecases/auth/login_user.dart';
import '../domain/usecases/auth/register_user.dart';
import '../presentation/bloc/auth/auth_bloc.dart';

/// Register authentication-related dependencies
Future<void> authInjection(GetIt sl) async {
  // Bloc
  sl.registerFactory(() => AuthBloc(
        loginUser: sl(),
        registerUser: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));

  // Repository
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton(() => DatabaseHelper.instance);
}
