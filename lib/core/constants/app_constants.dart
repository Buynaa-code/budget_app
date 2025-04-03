import 'package:flutter/material.dart';

/// Application constants
class AppConstants {
  // App details
  static const String appName = 'Budget App';
  static const String appVersion = '1.0.0';

  // API endpoints
  static const String baseUrl = 'https://api.example.com';

  // Asset paths
  static const String langPath = 'assets/lang/';
  static const String imagesPath = 'assets/images/';

  // Animation durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Database details
  static const String databaseName = 'budget_app.db';
  static const int databaseVersion = 1;
}

/// Route constants for the application
class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String transactions = '/transactions';
  static const String profile = '/profile';
  static const String editProfile = '/edit_profile';
}

/// Color constants for the application
class AppColors {
  static const Color primaryColor = Color(0xFF446CEF);
  static const Color accentColor = Color(0xFF4A5CFF);
  static const Color darkBackground = Color(0xFF1A1B1E);
  static const Color darkSurface = Color(0xFF2A2B2E);
  static const Color darkText = Color(0xFFFFFFFF);
  static const Color lightBackground = Color(0xFFF5F5F5);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1A1B1E);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);
}

/// Text constants for the application
class AppTextStyles {
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
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
