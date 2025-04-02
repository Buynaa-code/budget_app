import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../models/balance.dart';
import '../services/database_service.dart';

class TransactionProvider with ChangeNotifier {
  DatabaseService? _databaseService;
  List<TransactionModel>? _transactions;
  bool _isLoading = false;

  List<TransactionModel>? get transactions => _transactions;
  bool get isLoading => _isLoading;
  List<TransactionModel> get recentTransactions {
    if (_transactions == null) return [];
    // Sort by date (newest first) and take the last 5 transactions
    final sortedTransactions = List<TransactionModel>.from(_transactions!);
    sortedTransactions.sort((a, b) => b.date.compareTo(a.date));
    return sortedTransactions.take(5).toList();
  }

  Future<void> init(String uid) async {
    _databaseService = DatabaseService(uid: uid);
    await _listenToTransactions();
  }

  Future<void> _listenToTransactions() async {
    if (_databaseService != null) {
      await for (final transactions
          in _databaseService!.getUserTransactions()) {
        _transactions = transactions;
        notifyListeners();
      }
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> addTransaction(String title, double amount, TransactionType type,
      String category) async {
    if (_databaseService == null) return;

    setLoading(true);
    try {
      final String id = const Uuid().v4();
      final TransactionModel transaction = TransactionModel(
        id: id,
        userId: _databaseService!.uid,
        title: title,
        amount: amount,
        date: DateTime.now(),
        type: type,
        category: category,
      );

      // Update database first
      await _databaseService!.addTransaction(transaction);

      // Update balance
      await _updateBalance(transaction, true);

      // Update local transactions list immediately for UI responsiveness
      if (_transactions == null) {
        _transactions = [];
      }
      _transactions!.add(transaction);
      notifyListeners();

      // Provide user feedback
      print('Transaction added successfully');
    } catch (e) {
      print('Failed to add transaction: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    if (_databaseService == null) return;

    setLoading(true);
    try {
      // Update database first
      await _databaseService!.deleteTransaction(transaction.id);

      // Update balance
      await _updateBalance(transaction, false);

      // Provide user feedback
      print('Transaction deleted successfully');
    } catch (e) {
      print('Failed to delete transaction: $e');
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  Future<void> _updateBalance(
      TransactionModel transaction, bool isAddition) async {
    if (_databaseService == null) return;

    try {
      final balanceStream = _databaseService!.getUserBalance();
      final balance = await balanceStream.first;

      double totalBalance = balance.totalBalance;
      double availableBalance = balance.availableBalance;
      double income = balance.income;
      double expense = balance.expense;

      if (transaction.type == TransactionType.income) {
        if (isAddition) {
          totalBalance += transaction.amount;
          availableBalance += transaction.amount;
          income += transaction.amount;
        } else {
          totalBalance -= transaction.amount;
          availableBalance -= transaction.amount;
          income -= transaction.amount;
        }
      } else {
        if (isAddition) {
          totalBalance -= transaction.amount;
          availableBalance -= transaction.amount;
          expense += transaction.amount;
        } else {
          totalBalance += transaction.amount;
          availableBalance += transaction.amount;
          expense -= transaction.amount;
        }
      }

      await _databaseService!.updateBalance(
        balance.copyWith(
          totalBalance: totalBalance,
          availableBalance: availableBalance,
          income: income,
          expense: expense,
        ),
      );
    } catch (e) {
      print('Failed to update balance: $e');
      rethrow;
    }
  }
}

extension BalanceModelExtension on BalanceModel {
  BalanceModel copyWith({
    String? userId,
    double? totalBalance,
    double? availableBalance,
    double? income,
    double? expense,
  }) {
    return BalanceModel(
      userId: userId ?? this.userId,
      totalBalance: totalBalance ?? this.totalBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      income: income ?? this.income,
      expense: expense ?? this.expense,
    );
  }
}
