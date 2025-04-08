// import 'dart:async';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
import '../models/transaction.dart';
import '../models/balance.dart';
import '../models/user.dart';

// Mock database class
class Database {
  Future<int> insert(String table, Map<String, dynamic> values) async {
    return 1; // Mock successful insert with ID 1
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    return []; // Return empty list
  }

  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return 1; // Mock successful update affecting 1 row
  }

  Future<int> delete(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    return 1; // Mock successful delete affecting 1 row
  }

  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    return [
      {'total': 0.0}
    ]; // Mock query result with 0 total
  }

  Future<void> execute(String sql, [List<dynamic>? arguments]) async {
    // Mock execute - do nothing
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    _database ??= await _initDB('budget_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Return mock database
    return Database();
  }

  Future<void> _createDB(Database db, int version) async {
    // Mock implementation - do nothing
  }

  // User operations
  Future<int> createUser(UserModel user) async {
    return 1; // Mock successful insert
  }

  Future<UserModel?> getUser(String uid) async {
    // Return mock user
    return UserModel(
      uid: 'mock-user-id',
      email: 'test@example.com',
      name: 'Test User',
      phone: '1234567890',
    );
  }

  Future<int> updateUser(UserModel user) async {
    return 1; // Mock successful update
  }

  Future<int> deleteUser(String uid) async {
    return 1; // Mock successful delete
  }

  // Balance operations
  Future<int> createBalance(BalanceModel balance) async {
    return 1; // Mock successful insert
  }

  Future<BalanceModel?> getBalance(String userId) async {
    // Return mock balance
    return BalanceModel(
      id: 1,
      userId: userId,
      totalBalance: 1000.0,
      availableBalance: 800.0,
      income: 1500.0,
      expense: 700.0,
    );
  }

  Future<int> updateBalance(BalanceModel balance) async {
    return 1; // Mock successful update
  }

  // Transaction operations
  Future<int> createTransaction(TransactionModel transaction) async {
    return 1; // Mock successful insert
  }

  Future<List<TransactionModel>> getTransactions(String userId) async {
    // Return mock transactions
    return [
      TransactionModel(
        id: '1',
        title: 'Salary',
        amount: 1500.0,
        date: DateTime.now(),
        type: 'income',
        category: 'Income',
      ),
      TransactionModel(
        id: '2',
        title: 'Groceries',
        amount: 200.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        type: 'expense',
        category: 'Food',
      ),
    ];
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    return 1; // Mock successful update
  }

  Future<int> deleteTransaction(String id) async {
    return 1; // Mock successful delete
  }

  // Transaction statistics
  Future<Map<String, double>> getTransactionStats(String userId) async {
    // Return mock stats
    return {
      'monthlyIncome': 1500.0,
      'monthlyExpense': 700.0,
      'totalIncome': 3000.0,
      'totalExpense': 1200.0,
    };
  }

  // Get transactions by date range
  Future<List<TransactionModel>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Return mock transactions
    return getTransactions(userId);
  }

  // Get transactions by category
  Future<List<TransactionModel>> getTransactionsByCategory(
    String userId,
    String category,
  ) async {
    // Return mock transactions filtered by category
    final allTransactions = await getTransactions(userId);
    return allTransactions.where((t) => t.category == category).toList();
  }

  // Get transactions by type
  Future<List<TransactionModel>> getTransactionsByType(
    String userId,
    String type,
  ) async {
    // Return mock transactions filtered by type
    final allTransactions = await getTransactions(userId);
    return allTransactions.where((t) => t.type == type).toList();
  }

  // Search transactions
  Future<List<TransactionModel>> searchTransactions(
    String userId,
    String query,
  ) async {
    // Return mock search results
    final allTransactions = await getTransactions(userId);
    return allTransactions
        .where((t) => t.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get transaction count
  Future<int> getTransactionCount(String userId) async {
    // Mock implementation
    return 5;
  }

  // Check if database is empty
  Future<bool> isDatabaseEmpty() async {
    // Mock implementation
    return false; // Database is not empty
  }

  // Close the database
  Future<void> close() async {
    // Mock implementation - do nothing
  }

  // Get record count
  Future<int> getRecordCount(String table) async {
    // Mock implementation
    return 10;
  }

  // Get database statistics
  Future<Map<String, int>> getDatabaseStatistics() async {
    // Mock implementation
    return {
      'users': 5,
      'transactions': 25,
      'balances': 5,
    };
  }

  // Get batch size
  int getBatchSize() {
    // Mock implementation
    return 100;
  }
}
