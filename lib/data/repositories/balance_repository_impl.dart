import 'dart:async';
import '../../domain/entities/balance_entity.dart';
import '../../domain/repositories/balance_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/balance_model.dart';

/// Implementation of the BalanceRepository interface
class BalanceRepositoryImpl implements BalanceRepository {
  final DatabaseHelper _databaseHelper;
  final _balanceStreamController = StreamController<BalanceEntity>.broadcast();

  BalanceRepositoryImpl(this._databaseHelper);

  @override
  Future<BalanceEntity?> getBalance(String userId) async {
    return await _databaseHelper.getBalance(userId);
  }

  @override
  Future<bool> createBalance(BalanceEntity balance) async {
    try {
      final balanceModel = balance as BalanceModel;
      final result = await _databaseHelper.createBalance(balanceModel);

      // Update the stream with new balance
      _updateBalanceStream(balance.userId);

      return result > 0;
    } catch (e) {
      print('Create balance error: $e');
      return false;
    }
  }

  @override
  Future<bool> updateBalance(BalanceEntity balance) async {
    try {
      final balanceModel = balance as BalanceModel;
      final result = await _databaseHelper.updateBalance(balanceModel);

      // Update the stream with new balance
      _updateBalanceStream(balance.userId);

      return result > 0;
    } catch (e) {
      print('Update balance error: $e');
      return false;
    }
  }

  @override
  Stream<BalanceEntity> watchBalance(String userId) {
    // Initialize the stream with current data
    _updateBalanceStream(userId);
    return _balanceStreamController.stream;
  }

  // Helper method to update the balance stream
  Future<void> _updateBalanceStream(String userId) async {
    final balance = await _databaseHelper.getBalance(userId);
    if (balance != null) {
      _balanceStreamController.add(balance);
    } else {
      // Create a default balance if none exists
      final defaultBalance = BalanceModel(
        userId: userId,
        totalBalance: 0,
        availableBalance: 0,
        income: 0,
        expense: 0,
      );
      await _databaseHelper.createBalance(defaultBalance);
      _balanceStreamController.add(defaultBalance);
    }
  }

  // Clean up resources
  void dispose() {
    _balanceStreamController.close();
  }
}
