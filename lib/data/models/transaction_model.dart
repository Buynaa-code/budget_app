import '../../domain/entities/transaction_entity.dart';

/// Data model class for Transaction entity with serialization methods.
class TransactionModel extends TransactionEntity {
  TransactionModel({
    required String id,
    required String userId,
    required String title,
    required double amount,
    required DateTime date,
    required String type,
    required String category,
  }) : super(
          id: id,
          userId: userId,
          title: title,
          amount: amount,
          date: date,
          type: type,
          category: category,
        );

  /// Create a TransactionModel from a map (e.g., from database or API).
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
      type: map['type'] ?? '',
      category: map['category'] ?? '',
    );
  }

  /// Convert the TransactionModel to a map for persistence.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type,
      'category': category,
    };
  }

  /// Create a copy of the TransactionModel with optional changes.
  TransactionModel copyWith({
    String? id,
    String? userId,
    String? title,
    double? amount,
    DateTime? date,
    String? type,
    String? category,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
    );
  }
}
