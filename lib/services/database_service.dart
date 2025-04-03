import 'dart:async';
import '../models/transaction.dart';
import '../models/balance.dart';
import '../models/user.dart';
import 'database_helper.dart';

class DatabaseService {
  final String uid;

  // Stream controllers to broadcast updates
  final _transactionController =
      StreamController<List<TransactionModel>>.broadcast();
  final _balanceController = StreamController<BalanceModel>.broadcast();

  DatabaseService({required this.uid}) {
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Load data from SQLite and emit initial values
    final transactions = await DatabaseHelper.instance.getTransactions(uid);
    _transactionController.add(transactions);

    final balance = await DatabaseHelper.instance.getBalance(uid);
    if (balance != null) {
      _balanceController.add(balance);
    } else {
      // Create default balance if not exists
      final defaultBalance = BalanceModel(
        userId: uid,
        totalBalance: 3200500,
        availableBalance: 750000,
        income: 750000,
        expense: 750000,
      );
      await DatabaseHelper.instance.createBalance(defaultBalance);
      _balanceController.add(defaultBalance);
    }
  }

  // Save user data
  Future<void> saveUserData(String email, String? name, String? phone,
      {String? photoUrl}) async {
    final existingUser = await DatabaseHelper.instance.getUser(uid);

    final user = UserModel(
      uid: uid,
      email: email,
      name: name,
      phone: phone,
      photoUrl: photoUrl ?? existingUser?.photoUrl,
    );

    if (existingUser == null) {
      await DatabaseHelper.instance.createUser(user);
    } else {
      await DatabaseHelper.instance.updateUser(user);
    }
  }

  // Update profile image
  Future<bool> updateProfileImage(String imagePath) async {
    try {
      final existingUser = await DatabaseHelper.instance.getUser(uid);
      if (existingUser != null) {
        final updatedUser = existingUser.copyWith(photoUrl: imagePath);
        await DatabaseHelper.instance.updateUser(updatedUser);
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating profile image: $e');
      return false;
    }
  }

  // Add transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.createTransaction(transaction);

    // Refresh transactions list after adding
    final transactions = await DatabaseHelper.instance.getTransactions(uid);
    _transactionController.add(transactions);
  }

  // Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    await DatabaseHelper.instance.deleteTransaction(transactionId);

    // Refresh transactions list after deleting
    final transactions = await DatabaseHelper.instance.getTransactions(uid);
    _transactionController.add(transactions);
  }

  // Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    await DatabaseHelper.instance.updateTransaction(transaction);

    // Refresh transactions list after updating
    final transactions = await DatabaseHelper.instance.getTransactions(uid);
    _transactionController.add(transactions);
  }

  // Update balance
  Future<void> updateBalance(BalanceModel balance) async {
    await DatabaseHelper.instance.updateBalance(balance);

    // Refresh balance after updating
    final updatedBalance = await DatabaseHelper.instance.getBalance(uid);
    if (updatedBalance != null) {
      _balanceController.add(updatedBalance);
    }
  }

  // Get user data
  Future<UserModel?> getUserData() async {
    return await DatabaseHelper.instance.getUser(uid);
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
