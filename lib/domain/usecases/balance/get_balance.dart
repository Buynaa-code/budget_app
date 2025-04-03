import '../../entities/balance_entity.dart';
import '../../repositories/balance_repository.dart';

/// Use case for retrieving a user's balance.
class GetBalance {
  final BalanceRepository repository;

  GetBalance(this.repository);

  /// Execute the get balance use case with user ID.
  Future<BalanceEntity?> call(String userId) async {
    return await repository.getBalance(userId);
  }
}
