class BalanceModel {
  final int? id;
  final String userId;
  final double totalBalance;
  final double availableBalance;
  final double income;
  final double expense;
  final DateTime? updatedAt;

  BalanceModel({
    this.id,
    required this.userId,
    required this.totalBalance,
    required this.availableBalance,
    required this.income,
    required this.expense,
    this.updatedAt,
  });

  factory BalanceModel.fromMap(Map<String, dynamic> map) {
    return BalanceModel(
      id: map['id'] != null ? int.parse(map['id'].toString()) : null,
      userId: map['userId'] ?? '',
      totalBalance: map['totalBalance']?.toDouble() ?? 0.0,
      availableBalance: map['availableBalance']?.toDouble() ?? 0.0,
      income: map['income']?.toDouble() ?? 0.0,
      expense: map['expense']?.toDouble() ?? 0.0,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'userId': userId,
      'totalBalance': totalBalance,
      'availableBalance': availableBalance,
      'income': income,
      'expense': expense,
    };

    if (id != null) {
      map['id'] = id.toString();
    }

    if (updatedAt != null) {
      map['updatedAt'] = updatedAt!.toIso8601String();
    }

    return map;
  }

  BalanceModel copyWith({
    int? id,
    String? userId,
    double? totalBalance,
    double? availableBalance,
    double? income,
    double? expense,
    DateTime? updatedAt,
  }) {
    return BalanceModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      totalBalance: totalBalance ?? this.totalBalance,
      availableBalance: availableBalance ?? this.availableBalance,
      income: income ?? this.income,
      expense: expense ?? this.expense,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
