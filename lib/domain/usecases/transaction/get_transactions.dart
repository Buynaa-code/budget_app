import '../../entities/transaction_entity.dart';
import '../../repositories/transaction_repository.dart';
import 'package:budget_app/models/transaction.dart';

/// Use case for retrieving all transactions for a user.
class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  /// Execute the get transactions use case.
  Future<List<TransactionEntity>> call() async {
    final transactions = await repository.getTransactions();
    return transactions
        .map((model) => TransactionEntity.fromModel(model))
        .toList();
  }
}
