import 'package:flutter/material.dart';

// App Colors
class AppColors {
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.blueAccent;
  static const Color backgroundColor = Colors.black;
  static const Color cardColor = Color(0xFF0D47A1); // dark blue
  static const Color incomeColor = Colors.green;
  static const Color expenseColor = Colors.red;
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = Colors.white70;
}

// Text Styles
class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimaryColor,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: AppColors.textSecondaryColor,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimaryColor,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondaryColor,
  );
}

// Transaction Categories
class TransactionCategories {
  static const List<String> income = [
    'Salary',
    'Bonus',
    'Investment',
    'Gift',
    'Other',
  ];

  static const List<String> expense = [
    'Shopping',
    'Food',
    'Transport',
    'Entertainment',
    'Bills',
    'Health',
    'Education',
    'Other',
  ];
}

// App Routes
class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String transactions = '/transactions';
  static const String profile = '/profile';
}

// Date Formats
class DateFormats {
  static const String dayMonthYear = 'dd/MM/yyyy';
  static const String monthYear = 'MMMM yyyy';
  static const String dayMonth = 'dd MMM';
}

// Error Messages
class ErrorMessages {
  static const String authFailed = 'Authentication failed. Please try again.';
  static const String emailInvalid = 'Please enter a valid email address.';
  static const String passwordWeak =
      'Password should be at least 6 characters.';
  static const String fieldRequired = 'This field is required.';
  static const String transactionError =
      'Failed to process transaction. Please try again.';
}
