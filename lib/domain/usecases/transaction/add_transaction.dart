import 'package:budget_app/models/transaction.dart';

import '../../entities/transaction_entity.dart';
// Ensure you import the TransactionModel
import '../../repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repository;

  AddTransaction(this.repository);

  Future<bool> call(TransactionEntity transactionEntity) async {
    try {
      // Convert TransactionEntity to TransactionModel
      final transactionModel = TransactionModel(
        id: transactionEntity.id,
        title: transactionEntity.title,
        amount: transactionEntity.amount,
        date: transactionEntity.date,
        type: transactionEntity.type, // Ensure this matches the expected type
        category: transactionEntity.category,
      );

      await repository.addTransaction(transactionModel);
      return true;
    } catch (e) {
      return false;
    }
  }
}
