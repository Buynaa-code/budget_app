import 'package:budget_app/models/transaction.dart';

/// Entity representing a financial transaction in the application domain.
class TransactionEntity {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final String type;
  final String category;

  TransactionEntity({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });

  factory TransactionEntity.fromModel(TransactionModel model) {
    return TransactionEntity(
      id: model.id,
      title: model.title,
      amount: model.amount,
      date: model.date,
      type: model.type,
      category: model.category,
    );
  }

  TransactionModel toModel() {
    return TransactionModel(
      id: id,
      title: title,
      amount: amount,
      date: date,
      type: type,
      category: category,
    );
  }
}
