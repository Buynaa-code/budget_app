class BalanceModel {
  final String userId;
  final double totalBalance;
  final double availableBalance;
  final double income;
  final double expense;

  BalanceModel({
    required this.userId,
    required this.totalBalance,
    required this.availableBalance,
    required this.income,
    required this.expense,
  });

  factory BalanceModel.fromMap(Map<String, dynamic> map) {
    return BalanceModel(
      userId: map['userId'] ?? '',
      totalBalance: map['totalBalance']?.toDouble() ?? 0.0,
      availableBalance: map['availableBalance']?.toDouble() ?? 0.0,
      income: map['income']?.toDouble() ?? 0.0,
      expense: map['expense']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalBalance': totalBalance,
      'availableBalance': availableBalance,
      'income': income,
      'expense': expense,
    };
  }
}
