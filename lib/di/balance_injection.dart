import 'package:get_it/get_it.dart';
import '../data/repositories/balance_repository_impl.dart';
import '../domain/repositories/balance_repository.dart';
import '../domain/usecases/balance/get_balance.dart';
import '../domain/usecases/balance/update_balance.dart';

/// Register balance-related dependencies
Future<void> balanceInjection(GetIt sl) async {
  // Use cases
  sl.registerLazySingleton(() => GetBalance(sl()));
  sl.registerLazySingleton(() => UpdateBalance(sl()));

  // Repository
  sl.registerLazySingleton<BalanceRepository>(
    () => BalanceRepositoryImpl(sl()),
  );
}
