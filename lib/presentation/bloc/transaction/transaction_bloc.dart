import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budget_app/models/transaction.dart';
import 'package:budget_app/domain/entities/transaction_entity.dart';
import 'package:budget_app/domain/usecases/transaction/add_transaction.dart'
    as add_transaction;
import 'package:budget_app/domain/usecases/transaction/get_transactions.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';

/// BLoC for handling transaction operations
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactions getTransactions;
  final add_transaction.AddTransaction addTransaction;

  TransactionBloc({
    required this.getTransactions,
    required this.addTransaction,
  }) : super(const TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<UpdateTransaction>(_onUpdateTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
    on<SearchTransactions>(_onSearchTransactions);
  }

  /// Handle LoadTransactions event
  Future<void> _onLoadTransactions(
    LoadTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    emit(const TransactionLoading());
    try {
      final transactions = await getTransactions();
      final totalIncome = transactions
          .where((t) => t.type == 'income')
          .fold(0.0, (sum, t) => sum + t.amount);
      final totalExpense = transactions
          .where((t) => t.type == 'expense')
          .fold(0.0, (sum, t) => sum + t.amount);
      final balance = totalIncome - totalExpense;

      emit(TransactionLoaded(
        transactions: transactions.map((e) => e.toModel()).toList(),
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        balance: balance,
      ));
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  /// Handle AddTransaction event
  Future<void> _onAddTransaction(
    AddTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    try {
      final result = await addTransaction(
        TransactionEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: event.title,
          amount: event.amount,
          date: DateTime.now(),
          type: event.type == TransactionType.income ? 'income' : 'expense',
          category: event.category,
        ),
      );

      if (result) {
        emit(const TransactionOperationSuccess(
          operation: TransactionOperation.add,
          message: 'Transaction added successfully',
        ));
        add(const LoadTransactions());
      } else {
        emit(const TransactionError('Failed to add transaction'));
      }
    } catch (e) {
      emit(TransactionError(e.toString()));
    }
  }

  /// Handle UpdateTransaction event
  Future<void> _onUpdateTransaction(
    UpdateTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    // TODO: Implement update transaction
  }

  /// Handle DeleteTransaction event
  Future<void> _onDeleteTransaction(
    DeleteTransaction event,
    Emitter<TransactionState> emit,
  ) async {
    // TODO: Implement delete transaction
  }

  /// Handle SearchTransactions event
  Future<void> _onSearchTransactions(
    SearchTransactions event,
    Emitter<TransactionState> emit,
  ) async {
    // TODO: Implement search transactions
  }
}
