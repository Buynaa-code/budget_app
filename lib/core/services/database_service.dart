import 'package:budget_app/models/transaction.dart';

abstract class DatabaseService {
  String get uid;

  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
}
