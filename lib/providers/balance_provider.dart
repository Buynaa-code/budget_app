import 'package:flutter/material.dart';
import '../models/balance.dart';
import '../services/database_helper.dart';

class BalanceProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  BalanceModel? _balance;
  bool _isLoading = false;

  BalanceModel? get balance => _balance;
  bool get isLoading => _isLoading;

  Future<void> init(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _balance = await _db.getBalance(userId);
    } catch (e) {
      print('Error initializing balance: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBalance(BalanceModel balance) async {
    try {
      await _db.updateBalance(balance);
      _balance = balance;
      notifyListeners();
    } catch (e) {
      print('Error updating balance: $e');
      rethrow;
    }
  }
}
