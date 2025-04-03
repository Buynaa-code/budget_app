import '../../domain/entities/balance_entity.dart';

/// Data model class for Balance entity with serialization methods.
class BalanceModel extends BalanceEntity {
  BalanceModel({
    required String userId,
    required double totalBalance,
    required double availableBalance,
    required double income,
    required double expense,
    DateTime? updatedAt,
  }) : super(
          userId: userId,
          totalBalance: totalBalance,
          availableBalance: availableBalance,
          income: income,
          expense: expense,
          updatedAt: updatedAt ?? DateTime.now(),
        );

  /// Create a BalanceModel from a map (e.g., from database or API).
  factory BalanceModel.fromMap(Map<String, dynamic> map) {
    return BalanceModel(
      userId: map['userId'] ?? '',
      totalBalance: map['totalBalance']?.toDouble() ?? 0.0,
      availableBalance: map['availableBalance']?.toDouble() ?? 0.0,
      income: map['income']?.toDouble() ?? 0.0,
      expense: map['expense']?.toDouble() ?? 0.0,
      updatedAt: map['updatedAt'] != null
          ? DateTime.parse(map['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Convert the BalanceModel to a map for persistence.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalBalance': totalBalance,
      'availableBalance': availableBalance,
      'income': income,
      'expense': expense,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create a copy of the BalanceModel with optional changes.
  BalanceModel copyWith({
    String? userId,
    double? totalBalance,
    double? availableBalance,
    double? income,
    double? expense,
    DateTime? updatedAt,
  }) {
    return BalanceModel(
      userId: userId ?? this.userId,
      totalBalance: totalBalance ?? this.totalBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
