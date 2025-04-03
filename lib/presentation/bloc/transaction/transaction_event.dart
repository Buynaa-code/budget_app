import 'package:equatable/equatable.dart';
import 'package:budget_app/models/transaction.dart';

/// Events for the TransactionBloc
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

/// Loads all transactions
class LoadTransactions extends TransactionEvent {
  const LoadTransactions();
}

/// Adds a new transaction
class AddTransaction extends TransactionEvent {
  final String title;
  final double amount;
  final TransactionType type;
  final String category;

  const AddTransaction({
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
  });

  @override
  List<Object> get props => [title, amount, type, category];
}

/// Updates an existing transaction
class UpdateTransaction extends TransactionEvent {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final String category;

  const UpdateTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
  });

  @override
  List<Object> get props => [id, title, amount, type, category];
}

/// Deletes a transaction
class DeleteTransaction extends TransactionEvent {
  final String id;

  const DeleteTransaction(this.id);

  @override
  List<Object> get props => [id];
}

/// Searches for transactions
class SearchTransactions extends TransactionEvent {
  final String query;

  const SearchTransactions(this.query);

  @override
  List<Object> get props => [query];
}
