import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart';
import '../models/balance.dart';
import '../models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('budget_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE users (
        uid TEXT PRIMARY KEY,
        email TEXT NOT NULL,
        name TEXT,
        phone TEXT,
        photoUrl TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create balances table
    await db.execute('''
      CREATE TABLE balances (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId TEXT NOT NULL,
        totalBalance REAL NOT NULL,
        availableBalance REAL NOT NULL,
        income REAL NOT NULL,
        expense REAL NOT NULL,
        updatedAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (uid)
      )
    ''');

    // Create transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        category TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (uid)
      )
    ''');
  }

  // User operations
  Future<int> createUser(UserModel user) async {
    final db = await database;
    return await db.insert('users', user.toMap());
  }

  Future<UserModel?> getUser(String uid) async {
    final db = await database;
    final maps = await db.query(
      'users',
      where: 'uid = ?',
      whereArgs: [uid],
    );

    if (maps.isNotEmpty) {
      return UserModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUser(UserModel user) async {
    final db = await database;
    return await db.update(
      'users',
      user.toMap(),
      where: 'uid = ?',
      whereArgs: [user.uid],
    );
  }

  Future<int> deleteUser(String uid) async {
    final db = await database;
    // Delete related balances and transactions first
    await db.delete('balances', where: 'userId = ?', whereArgs: [uid]);
    await db.delete('transactions', where: 'userId = ?', whereArgs: [uid]);
    return await db.delete('users', where: 'uid = ?', whereArgs: [uid]);
  }

  // Balance operations
  Future<int> createBalance(BalanceModel balance) async {
    final db = await database;
    final map = balance.toMap();
    map['updatedAt'] = DateTime.now().toIso8601String();
    return await db.insert('balances', map);
  }

  Future<BalanceModel?> getBalance(String userId) async {
    final db = await database;
    final maps = await db.query(
      'balances',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'updatedAt DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return BalanceModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBalance(BalanceModel balance) async {
    final db = await database;
    final map = balance.toMap();
    map['updatedAt'] = DateTime.now().toIso8601String();

    // Check if balance exists
    final existingBalance = await getBalance(balance.userId);
    if (existingBalance != null) {
      return await db.update(
        'balances',
        map,
        where: 'userId = ?',
        whereArgs: [balance.userId],
      );
    } else {
      return await createBalance(balance);
    }
  }

  // Transaction operations
  Future<int> createTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getTransactions(String userId) async {
    final db = await database;
    final maps = await db.query(
      'transactions',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  Future<int> deleteTransaction(String id) async {
    final db = await database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Transaction statistics
  Future<Map<String, double>> getTransactionStats(String userId) async {
    final db = await database;
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1).toIso8601String();
    final nextMonth = DateTime(now.year, now.month + 1, 1).toIso8601String();

    // Get this month's income
    final incomeResult = await db.rawQuery('''
      SELECT COALESCE(SUM(amount), 0) as total
      FROM transactions
      WHERE userId = ? AND type = 'income' AND date >= ? AND date < ?
    ''', [userId, currentMonth, nextMonth]);

    // Get this month's expense
    final expenseResult = await db.rawQuery('''
      SELECT COALESCE(SUM(amount), 0) as total
      FROM transactions
      WHERE userId = ? AND type = 'expense' AND date >= ? AND date < ?
    ''', [userId, currentMonth, nextMonth]);

    // Get total income
    final totalIncomeResult = await db.rawQuery('''
      SELECT COALESCE(SUM(amount), 0) as total
      FROM transactions
      WHERE userId = ? AND type = 'income'
    ''', [userId]);

    // Get total expense
    final totalExpenseResult = await db.rawQuery('''
      SELECT COALESCE(SUM(amount), 0) as total
      FROM transactions
      WHERE userId = ? AND type = 'expense'
    ''', [userId]);

    return {
      'monthlyIncome': incomeResult.first['total'] as double? ?? 0.0,
      'monthlyExpense': expenseResult.first['total'] as double? ?? 0.0,
      'totalIncome': totalIncomeResult.first['total'] as double? ?? 0.0,
      'totalExpense': totalExpenseResult.first['total'] as double? ?? 0.0,
    };
  }

  // Get transactions by date range
  Future<List<TransactionModel>> getTransactionsByDateRange(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final startDateStr = startDate.toIso8601String();
    final endDateStr = endDate.toIso8601String();

    final maps = await db.query(
      'transactions',
      where: 'userId = ? AND date >= ? AND date <= ?',
      whereArgs: [userId, startDateStr, endDateStr],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  // Get transactions by category
  Future<List<TransactionModel>> getTransactionsByCategory(
    String userId,
    String category,
    TransactionType type,
  ) async {
    final db = await database;
    final typeStr = type == TransactionType.income ? 'income' : 'expense';

    final maps = await db.query(
      'transactions',
      where: 'userId = ? AND category = ? AND type = ?',
      whereArgs: [userId, category, typeStr],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  // Search transactions
  Future<List<TransactionModel>> searchTransactions(
    String userId,
    String query,
  ) async {
    final db = await database;

    final maps = await db.query(
      'transactions',
      where: 'userId = ? AND (title LIKE ? OR category LIKE ?)',
      whereArgs: [userId, '%$query%', '%$query%'],
      orderBy: 'date DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  // Get transaction count
  Future<int> getTransactionCount(String userId) async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT COUNT(*) as count
      FROM transactions
      WHERE userId = ?
    ''', [userId]);

    return Sqflite.firstIntValue(result) ?? 0;
  }

  // Check if database is empty
  Future<bool> isDatabaseEmpty() async {
    final db = await database;

    final usersCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM users'),
        ) ??
        0;

    final transactionsCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM transactions'),
        ) ??
        0;

    final balancesCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM balances'),
        ) ??
        0;

    return usersCount == 0 && transactionsCount == 0 && balancesCount == 0;
  }

  // Close the database
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
