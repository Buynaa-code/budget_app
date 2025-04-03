import 'package:get_it/get_it.dart';
import 'auth_injection.dart';
import 'transaction_injection.dart';
import 'profile_injection.dart';
import 'balance_injection.dart';

/// GetIt instance for dependency injection
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> init() async {
  // Register auth dependencies
  await authInjection(sl);

  // Register transaction dependencies
  await transactionInjection(sl);

  // Register profile dependencies
  await profileInjection(sl);

  // Register balance dependencies
  await balanceInjection(sl);
}
