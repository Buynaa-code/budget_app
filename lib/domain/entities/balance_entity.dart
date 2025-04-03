/// Entity representing a user's financial balance in the application domain.
class BalanceEntity {
  final String userId;
  final double totalBalance;
  final double availableBalance;
  final double income;
  final double expense;
  final DateTime updatedAt;

  const BalanceEntity({
    required this.userId,
    required this.totalBalance,
    required this.availableBalance,
    required this.income,
    required this.expense,
    required this.updatedAt,
  });
}
