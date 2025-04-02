import 'package:budget_app/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/balance_provider.dart';
import '../providers/transaction_provider.dart';
import '../app/app_localizations.dart';
import '../widgets/success_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _initializeData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      final balanceProvider =
          Provider.of<BalanceProvider>(context, listen: false);
      final transactionProvider =
          Provider.of<TransactionProvider>(context, listen: false);

      await balanceProvider.init(authProvider.user!.uid);
      await transactionProvider.init(authProvider.user!.uid);
    }
  }

  void _showTransactionDialog(BuildContext context, bool isIncome) {
    // Clear controllers before showing the dialog
    _amountController.clear();
    _descriptionController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1B1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(dialogContext).viewInsets.bottom,
              left: 16,
              right: 16,
              top: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isIncome ? '💰 Орлого нэмэх' : '💸 Зарлага нэмэх',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Мөнгөн дүн',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: const Color(0xFF2A2B2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon:
                        const Icon(Icons.monetization_on, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Тайлбар',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: const Color(0xFF2A2B2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon:
                        const Icon(Icons.description, color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_amountController.text.isEmpty) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          const SnackBar(
                            content: Text('Мөнгөн дүнгээ оруулна уу'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      try {
                        final amount = double.parse(_amountController.text);
                        if (amount <= 0) {
                          ScaffoldMessenger.of(dialogContext).showSnackBar(
                            const SnackBar(
                              content: Text('Мөнгөн дүн 0-ээс их байх ёстой'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        final description = _descriptionController.text;
                        final transactionProvider =
                            Provider.of<TransactionProvider>(
                          context,
                          listen: false,
                        );

                        await transactionProvider.addTransaction(
                          description.isEmpty
                              ? (isIncome ? 'Цалин' : 'Зарлага')
                              : description,
                          amount,
                          isIncome
                              ? TransactionType.income
                              : TransactionType.expense,
                          isIncome ? '💰 Орлого' : '💸 Зарлага',
                        );

                        // Clear controllers
                        _amountController.clear();
                        _descriptionController.clear();

                        // Show success message and dialog
                        if (context.mounted) {
                          Navigator.pop(context);
                          _showSuccessDialog(context, isIncome, amount);
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text('Алдаа гарлаа: ${e.toString()}'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isIncome ? Colors.green : Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isIncome ? 'Орлого нэмэх' : 'Зарлага нэмэх',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, bool isIncome, double amount) {
    SuccessDialogWidget.show(
      context: context,
      title: 'Амжилттай нэмэгдлээ!',
      message:
          'Таны ${amount.toStringAsFixed(0)}₮ ${isIncome ? 'орлого' : 'зарлага'} амжилттай нэмэгдлээ',
      buttonText: 'OK',
      accentColor: isIncome ? Colors.green : Colors.blue,
      onButtonPressed: () {
        // No need to do anything here as the dialog will handle its own dismissal
      },
      icon: Icons.rocket_launch,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF446CEF), Color(0xFF000000)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _initializeData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF4A5CFF), Color(0xFF3B4CCC)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).translate('balance'),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Consumer<BalanceProvider>(
                          builder: (context, balanceProvider, _) {
                            return Text(
                              '₮ ${balanceProvider.formatBalance(balanceProvider.totalBalance)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildQuickAction(
                              context,
                              icon: Icons.add_circle_outline,
                              title: 'Орлого Нэмэх',
                              onTap: () =>
                                  _showTransactionDialog(context, true),
                            ),
                            _buildQuickAction(
                              context,
                              icon: Icons.remove_circle_outline,
                              title: 'Зарлага Нэмэх',
                              onTap: () =>
                                  _showTransactionDialog(context, false),
                            ),
                            _buildQuickAction(
                              context,
                              icon: Icons.analytics_outlined,
                              title: 'Тайлан Харах',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Monthly Report Button
                  _buildReportButton(context),
                  const SizedBox(height: 24),
                  // Balance Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.3,
                    children: [
                      Consumer<BalanceProvider>(
                        builder: (context, balanceProvider, _) =>
                            _buildBalanceCard(
                          context,
                          icon: Icons.account_balance_wallet,
                          title: 'Таны Үлдэгдэл',
                          amount:
                              '${balanceProvider.formatBalance(balanceProvider.totalBalance)}₮',
                          color: Colors.orange,
                        ),
                      ),
                      Consumer<TransactionProvider>(
                        builder: (context, transactionProvider, _) {
                          final lastExpense = transactionProvider.transactions
                              ?.where((t) => t.type == TransactionType.expense)
                              .toList()
                            ?..sort((a, b) => b.date.compareTo(a.date));
                          final amount = lastExpense?.isNotEmpty == true
                              ? lastExpense!.first.amount
                              : 0;
                          return _buildBalanceCard(
                            context,
                            icon: Icons.arrow_upward,
                            title: 'Таны Сүүлийн Зарлага',
                            amount: '${amount.toStringAsFixed(0)}₮',
                            color: Colors.blue,
                          );
                        },
                      ),
                      Consumer<BalanceProvider>(
                        builder: (context, balanceProvider, _) =>
                            _buildBalanceCard(
                          context,
                          icon: Icons.arrow_downward,
                          title: 'Таны Орлого',
                          amount:
                              '${balanceProvider.formatBalance(balanceProvider.totalIncome)}₮',
                          color: Colors.green,
                        ),
                      ),
                      Consumer<BalanceProvider>(
                        builder: (context, balanceProvider, _) =>
                            _buildBalanceCard(
                          context,
                          icon: Icons.arrow_downward,
                          title: 'Энэ Сарын Нийт Зарлага',
                          amount:
                              '${balanceProvider.formatBalance(balanceProvider.totalExpense)}₮',
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Action Buttons and Tabs
                  DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2B2E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TabBar(
                            indicator: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey,
                            tabs: const [
                              Tab(text: '💸 Зарлага'),
                              Tab(text: '💰 Орлого'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 300, // Fixed height for the tab content
                          child: TabBarView(
                            children: [
                              // Expense List
                              Consumer<TransactionProvider>(
                                builder: (context, provider, _) {
                                  final expenses = provider.transactions
                                          ?.where((t) =>
                                              t.type == TransactionType.expense)
                                          .toList() ??
                                      [];

                                  // Sort expenses by date (newest first)
                                  expenses
                                      .sort((a, b) => b.date.compareTo(a.date));

                                  if (expenses.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.receipt_long_outlined,
                                            size: 48,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Одоогоор зарлага байхгүй байна',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    itemCount: expenses.length,
                                    itemBuilder: (context, index) {
                                      final transaction = expenses[index];
                                      return Dismissible(
                                        key: Key(transaction.id),
                                        background: Container(
                                          color: Colors.red,
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: const Icon(Icons.delete,
                                              color: Colors.white),
                                        ),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) {
                                          provider
                                              .deleteTransaction(transaction);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Зарлага устгагдлаа'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        },
                                        child: _buildListItem(
                                          '💸 ${transaction.title}',
                                          '${transaction.amount.toStringAsFixed(0)}₮',
                                          '📅 ${_formatDate(transaction.date)}',
                                          isExpense: true,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              // Income List
                              Consumer<TransactionProvider>(
                                builder: (context, provider, _) {
                                  final incomes = provider.transactions
                                          ?.where((t) =>
                                              t.type == TransactionType.income)
                                          .toList() ??
                                      [];

                                  // Sort incomes by date (newest first)
                                  incomes
                                      .sort((a, b) => b.date.compareTo(a.date));

                                  if (incomes.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons
                                                .account_balance_wallet_outlined,
                                            size: 48,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Одоогоор орлого байхгүй байна',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }

                                  return ListView.builder(
                                    itemCount: incomes.length,
                                    itemBuilder: (context, index) {
                                      final transaction = incomes[index];
                                      return Dismissible(
                                        key: Key(transaction.id),
                                        background: Container(
                                          color: Colors.red,
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(
                                              right: 20.0),
                                          child: const Icon(Icons.delete,
                                              color: Colors.white),
                                        ),
                                        direction: DismissDirection.endToStart,
                                        onDismissed: (direction) {
                                          provider
                                              .deleteTransaction(transaction);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Орлого устгагдлаа'),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                        },
                                        child: _buildListItem(
                                          '💰 ${transaction.title}',
                                          '${transaction.amount.toStringAsFixed(0)}₮',
                                          '📅 ${_formatDate(transaction.date)}',
                                          isExpense: false,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Recent Transactions
                  Consumer<TransactionProvider>(
                    builder: (context, transactionProvider, _) {
                      final transactions =
                          transactionProvider.recentTransactions;
                      return Column(
                        children: transactions.map((transaction) {
                          return _buildTransactionItem(context, transaction);
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF446CEF),
        elevation: 0,
        title: const Text(
          'BB',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildReportButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.rocket_launch, color: Colors.blue, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Өөрийн Сарын Тайланг Харах',
                  style: TextStyle(
                    color: Colors.blue[100],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '2024.03.29 Энэ Сарын Тайлан',
                  style: TextStyle(
                    color: Colors.blue[200]?.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: Colors.blue, size: 16),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
      BuildContext context, TransactionModel transaction) {
    final isExpense = transaction.type == TransactionType.expense;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isExpense
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isExpense ? Icons.shopping_bag : Icons.account_balance_wallet,
              color: isExpense ? Colors.red : Colors.green,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  transaction.category,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isExpense ? '-' : '+'}${transaction.amount.toStringAsFixed(0)}₮',
                style: TextStyle(
                  color: isExpense ? Colors.red : Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                transaction.date.toString().substring(0, 10),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, String amount, String subtitle,
      {bool isExpense = true}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2B2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isExpense
                  ? Colors.red.withOpacity(0.1)
                  : Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title.split(' ')[0], // Get the emoji
              style: const TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title
                      .substring(title.split(' ')[0].length)
                      .trim(), // Remove emoji from title
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Text(
            isExpense ? '-$amount' : '+$amount',
            style: TextStyle(
              color: isExpense ? Colors.red : Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }
}
