import 'package:flutter/material.dart';
import '../models/balance.dart';
import '../services/database_service.dart';

class BalanceProvider with ChangeNotifier {
  DatabaseService? _databaseService;
  BalanceModel? _balance;
  bool _isLoading = false;

  BalanceModel? get balance => _balance;
  bool get isLoading => _isLoading;
  double get totalBalance => _balance?.totalBalance ?? 0.0;
  double get totalIncome => _balance?.income ?? 0.0;
  double get totalExpense => _balance?.expense ?? 0.0;

  Future<void> init(String uid) async {
    _databaseService = DatabaseService(uid: uid);
    await _listenToBalance();
  }

  Future<void> _listenToBalance() async {
    if (_databaseService != null) {
      _databaseService!.getUserBalance().listen((balance) {
        _balance = balance;
        notifyListeners();
      });
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String formatBalance(double balance) {
    return '₮${balance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }
}
