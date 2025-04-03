import '../../entities/balance_entity.dart';
import '../../repositories/balance_repository.dart';

/// Use case for updating a user's balance.
class UpdateBalance {
  final BalanceRepository repository;

  UpdateBalance(this.repository);

  /// Execute the update balance use case with balance entity.
  Future<bool> call(BalanceEntity balance) async {
    return await repository.updateBalance(balance);
  }
}
