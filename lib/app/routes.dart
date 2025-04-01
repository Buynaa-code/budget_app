import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/transaction_screen.dart';
import '../screens/register_screen.dart';
import '../screens/main_navigation_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/dashboard': (context) => const MainNavigationScreen(),
  '/transactions': (context) => const TransactionScreen(),
};
