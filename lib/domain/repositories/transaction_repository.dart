import 'package:budget_app/models/transaction.dart';

/// Repository interface for transactions
abstract class TransactionRepository {
  /// Get all transactions
  Future<List<TransactionModel>> getTransactions();

  /// Add a new transaction
  Future<void> addTransaction(TransactionModel transaction);

  /// Update an existing transaction
  Future<void> updateTransaction(TransactionModel transaction);

  /// Delete a transaction
  Future<void> deleteTransaction(TransactionModel transaction);

  /// Search for transactions
  Future<List<TransactionModel>> searchTransactions(String query);

  /// Get recent transactions
  Future<List<TransactionModel>> getRecentTransactions({int limit = 5});
}
