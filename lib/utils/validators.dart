class Validators {
  // Email validator
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }

    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  // Password validator
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 6) {
      return 'Password should be at least 6 characters';
    }

    return null;
  }

  // Name validator
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }

    return null;
  }

  // Transaction amount validator
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter amount';
    }

    try {
      final amount = double.parse(value);
      if (amount <= 0) {
        return 'Amount should be greater than 0';
      }
    } catch (e) {
      return 'Please enter a valid number';
    }

    return null;
  }

  // Transaction title validator
  static String? validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter title';
    }

    return null;
  }

  // Check for duplicate transactions
  static bool isDuplicateTransaction(String title, double amount,
      String category, DateTime date, List<dynamic> recentTransactions) {
    // Check transactions from the last 24 hours
    final oneDayAgo = DateTime.now().subtract(const Duration(days: 1));

    int duplicateCount = 0;
    for (var transaction in recentTransactions) {
      if (transaction.title == title &&
          transaction.amount == amount &&
          transaction.category == category &&
          transaction.date.isAfter(oneDayAgo)) {
        duplicateCount++;
      }
    }

    // If there are already 2 or more similar transactions, flag as duplicate
    return duplicateCount >= 2;
  }
}
