import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/database_helper.dart';

class TransactionProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<TransactionModel>? _transactions;
  bool _isLoading = false;

  List<TransactionModel>? get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> init(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _db.getTransactions(userId);
    } catch (e) {
      print('Error initializing transactions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(
    String title,
    double amount,
    TransactionType type,
    String category,
  ) async {
    try {
      final transaction = TransactionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        amount: amount,
        date: DateTime.now(),
        type: type == TransactionType.income ? 'income' : 'expense',
        category: category,
      );

      await _db.createTransaction(transaction);
      _transactions?.insert(0, transaction);
      notifyListeners();
    } catch (e) {
      print('Error adding transaction: $e');
      rethrow;
    }
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    try {
      await _db.deleteTransaction(transaction.id);
      _transactions?.removeWhere((t) => t.id == transaction.id);
      notifyListeners();
    } catch (e) {
      print('Error deleting transaction: $e');
      rethrow;
    }
  }
}
