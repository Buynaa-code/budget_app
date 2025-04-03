import 'package:budget_app/core/services/database_service.dart';
import 'package:budget_app/data/services/database_service_impl.dart';
import 'package:budget_app/domain/repositories/transaction_repository.dart';
import 'package:budget_app/models/transaction.dart';

/// Implementation of the TransactionRepository interface using DatabaseService
class TransactionRepositoryImpl implements TransactionRepository {
  final DatabaseService _databaseService;

  /// Constructor that takes a DatabaseService instance
  TransactionRepositoryImpl({
    DatabaseService? databaseService,
  }) : _databaseService = databaseService ?? DatabaseServiceImpl();

  @override
  String get userId => _databaseService.uid;

  @override
  Future<List<TransactionModel>> getTransactions() async {
    return _databaseService.getTransactions();
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    await _databaseService.addTransaction(transaction);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _databaseService.updateTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(TransactionModel transaction) async {
    await _databaseService.deleteTransaction(transaction.id);
  }

  @override
  Future<List<TransactionModel>> searchTransactions(String query) async {
    final transactions = await _databaseService.getTransactions();
    return transactions.where((transaction) {
      final title = transaction.title.toLowerCase();
      final category = transaction.category.toLowerCase();
      final searchQuery = query.toLowerCase();
      return title.contains(searchQuery) || category.contains(searchQuery);
    }).toList();
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions({int limit = 5}) async {
    final transactions = await _databaseService.getTransactions();
    return transactions.take(limit).toList();
  }
}
