import 'dart:async';
import '../models/transaction.dart';
import '../models/balance.dart';

class DatabaseService {
  final String uid;
  // Mock data storage
  static final Map<String, List<TransactionModel>> _transactions = {};
  static final Map<String, BalanceModel> _balances = {};

  // Stream controllers to simulate real-time updates
  final _transactionController =
      StreamController<List<TransactionModel>>.broadcast();
  final _balanceController = StreamController<BalanceModel>.broadcast();

  DatabaseService({required this.uid}) {
    // Initialize empty data for new users
    if (!_transactions.containsKey(uid)) {
      _transactions[uid] = [];
    }
    if (!_balances.containsKey(uid)) {
      _balances[uid] = BalanceModel(
        userId: uid,
        totalBalance: 3200500,
        availableBalance: 750000,
        income: 750000,
        expense: 750000,
      );
    }

    // Initial data emission
    _transactionController.add(_transactions[uid]!);
    _balanceController.add(_balances[uid]!);
  }

  // Save user data
  Future<void> saveUserData(String email, String? name) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    // User data would be saved here
  }

  // Add transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    _transactions[uid]!.add(transaction);
    _transactionController.add(_transactions[uid]!);
  }

  // Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    _transactions[uid]!
        .removeWhere((transaction) => transaction.id == transactionId);
    _transactionController.add(_transactions[uid]!);
  }

  // Update balance
  Future<void> updateBalance(BalanceModel balance) async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate network delay
    _balances[uid] = balance;
    _balanceController.add(balance);
  }

  // Get user transactions
  Stream<List<TransactionModel>> getUserTransactions() {
    return _transactionController.stream;
  }

  // Get user balance
  Stream<BalanceModel> getUserBalance() {
    return _balanceController.stream;
  }

  // Cleanup
  void dispose() {
    _transactionController.close();
    _balanceController.close();
  }
}
