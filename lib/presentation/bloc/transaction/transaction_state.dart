import 'package:equatable/equatable.dart';
import 'package:budget_app/models/transaction.dart';

/// States for the TransactionBloc
abstract class TransactionState extends Equatable {
  final List<TransactionModel> transactions;
  final List<TransactionModel> expenses;
  final List<TransactionModel> incomes;
  final List<TransactionModel> recentTransactions;
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;
  final TransactionModel? lastExpense;
  final bool isLoading;
  final String? error;

  const TransactionState({
    this.transactions = const [],
    this.expenses = const [],
    this.incomes = const [],
    this.recentTransactions = const [],
    this.totalBalance = 0.0,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
    this.lastExpense,
    this.isLoading = false,
    this.error,
  });

  @override
  List<Object?> get props => [
        transactions,
        expenses,
        incomes,
        recentTransactions,
        totalBalance,
        totalIncome,
        totalExpense,
        lastExpense,
        isLoading,
        error,
      ];
}

/// Initial state before any events are dispatched
class TransactionInitial extends TransactionState {
  const TransactionInitial() : super();
}

/// Loading state while transactions are being fetched or updated
class TransactionLoading extends TransactionState {
  const TransactionLoading() : super(isLoading: true);
}

/// Loaded state with transactions data
class TransactionLoaded extends TransactionState {
  @override
  final List<TransactionModel> transactions;
  @override
  final double totalIncome;
  @override
  final double totalExpense;
  final double balance;

  const TransactionLoaded({
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  }) : super(
          transactions: transactions,
          totalIncome: totalIncome,
          totalExpense: totalExpense,
          totalBalance: balance,
        );

  @override
  List<Object?> get props => [
        transactions,
        totalIncome,
        totalExpense,
        totalBalance,
      ];
}

/// Transaction operation success state
class TransactionOperationSuccess extends TransactionState {
  final TransactionOperation operation;
  final String message;

  const TransactionOperationSuccess({
    required this.operation,
    required this.message,
  }) : super();

  @override
  List<Object?> get props => [operation, message];
}

/// Transaction operation error state
class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message) : super(error: message);

  @override
  List<Object?> get props => [message];
}

/// Enum for transaction operations
enum TransactionOperation {
  add,
  update,
  delete,
}
