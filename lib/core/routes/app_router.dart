import 'package:flutter/material.dart';
import '../../presentation/pages/auth/login_screen.dart';
import '../../presentation/pages/auth/register_screen.dart';
import '../../presentation/pages/dashboard/main_navigation_screen.dart';
import '../../presentation/pages/transaction/transaction_screen.dart';
import '../../presentation/pages/profile/profile_screen.dart';
import '../../presentation/pages/profile/edit_profile_screen.dart';
import '../constants/app_constants.dart';

/// Application router that defines all the routes in the app
class AppRouter {
  /// Map of routes for MaterialApp
  static final Map<String, WidgetBuilder> routes = {
    AppRoutes.login: (context) => const LoginScreen(),
    AppRoutes.register: (context) => const RegisterScreen(),
    AppRoutes.dashboard: (context) => const MainNavigationScreen(),
    AppRoutes.transactions: (context) => const TransactionScreen(),
    AppRoutes.profile: (context) => const ProfileScreen(),
    AppRoutes.editProfile: (context) => const EditProfileScreen(),
  };

  /// Navigate to a named route
  static Future<dynamic> navigateTo(BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  /// Navigate to a named route and remove all previous routes
  static Future<dynamic> navigateAndRemoveUntil(
      BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.pushNamedAndRemoveUntil(
        context, routeName, (route) => false,
        arguments: arguments);
  }

  /// Navigate to a named route and replace the current route
  static Future<dynamic> navigateAndReplace(
      BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.pushReplacementNamed(context, routeName,
        arguments: arguments);
  }

  /// Pop the current route
  static void pop(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }

  /// Check if can pop the current route
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Pop until a specific route
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }
}
