import 'package:intl/intl.dart';
import '../models/transaction.dart';

class Helpers {
  // Format currency
  static String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(
      symbol: '₮',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  // Format date
  static String formatDate(DateTime date, {String format = 'dd/MM/yyyy'}) {
    final formatter = DateFormat(format);
    return formatter.format(date);
  }

  // Calculate total balance
  static double calculateTotalBalance(List<TransactionModel> transactions) {
    double total = 0;
    for (var transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        total += transaction.amount;
      } else {
        total -= transaction.amount;
      }
    }
    return total;
  }

  // Calculate total income
  static double calculateTotalIncome(List<TransactionModel> transactions) {
    double total = 0;
    for (var transaction in transactions) {
      if (transaction.type == TransactionType.income) {
        total += transaction.amount;
      }
    }
    return total;
  }

  // Calculate total expense
  static double calculateTotalExpense(List<TransactionModel> transactions) {
    double total = 0;
    for (var transaction in transactions) {
      if (transaction.type == TransactionType.expense) {
        total += transaction.amount;
      }
    }
    return total;
  }

  // Filter transactions by type
  static List<TransactionModel> filterTransactionsByType(
    List<TransactionModel> transactions,
    TransactionType type,
  ) {
    return transactions
        .where((transaction) => transaction.type == type)
        .toList();
  }

  // Filter transactions by date range
  static List<TransactionModel> filterTransactionsByDateRange(
    List<TransactionModel> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    return transactions.where((transaction) {
      return transaction.date.isAfter(startDate) &&
          transaction.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  // Filter transactions by category
  static List<TransactionModel> filterTransactionsByCategory(
    List<TransactionModel> transactions,
    String category,
  ) {
    return transactions
        .where((transaction) => transaction.category == category)
        .toList();
  }

  // Get transactions from current month
  static List<TransactionModel> getCurrentMonthTransactions(
      List<TransactionModel> transactions) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    return filterTransactionsByDateRange(
        transactions, startOfMonth, endOfMonth);
  }

  // Check for duplicate transactions
  static bool hasDuplicateTransactions(
      List<TransactionModel> transactions, TransactionModel newTransaction) {
    final last24Hours = DateTime.now().subtract(const Duration(hours: 24));

    int duplicateCount = 0;
    for (var transaction in transactions) {
      if (transaction.title == newTransaction.title &&
          transaction.amount == newTransaction.amount &&
          transaction.type == newTransaction.type &&
          transaction.category == newTransaction.category &&
          transaction.date.isAfter(last24Hours)) {
        duplicateCount++;
      }
    }

    return duplicateCount >= 2;
  }
}
