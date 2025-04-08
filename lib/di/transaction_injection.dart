import 'package:get_it/get_it.dart';
import '../data/repositories/transaction_repository_impl.dart';
import '../domain/repositories/transaction_repository.dart';
import '../domain/usecases/transaction/add_transaction.dart';
import '../domain/usecases/transaction/get_transactions.dart';
import '../presentation/bloc/transaction/transaction_bloc.dart';

/// Register transaction-related dependencies
Future<void> transactionInjection(GetIt sl) async {
  // Bloc
  sl.registerFactory(() => TransactionBloc(
        getTransactions: sl(),
        addTransaction: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => GetTransactions(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(),
  );
}
