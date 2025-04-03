import '../entities/balance_entity.dart';

/// Repository interface for balance-related operations.
abstract class BalanceRepository {
  /// Get balance for a specific user
  Future<BalanceEntity?> getBalance(String userId);

  /// Create initial balance for a user
  Future<bool> createBalance(BalanceEntity balance);

  /// Update user balance
  Future<bool> updateBalance(BalanceEntity balance);

  /// Listen to balance changes
  Stream<BalanceEntity> watchBalance(String userId);
}
