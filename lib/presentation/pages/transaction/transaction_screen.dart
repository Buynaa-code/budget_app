import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:budget_app/providers/auth_provider.dart';
import 'package:budget_app/providers/transaction_provider.dart';
import 'package:budget_app/models/transaction.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.userModel != null) {
        Provider.of<TransactionProvider>(context, listen: false)
            .init(authProvider.userModel!.uid);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Гүйлгээнүүд'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Бүгд'),
            Tab(text: 'Шүүх'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All transactions tab
          _buildTransactionList(transactionProvider.transactions ?? []),

          // Filter tab
          _buildFilterOptions(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTransactionDialog(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTransactionList(List<TransactionModel> transactions) {
    if (transactions.isEmpty) {
      return const Center(
        child: Text(
          'No transactions yet',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    // Sort transactions by date (newest first)
    transactions.sort((a, b) => b.date.compareTo(a.date));

    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionItem(transaction);
      },
    );
  }

  Widget _buildTransactionItem(TransactionModel transaction) {
    final isExpense = transaction.type == TransactionType.expense;
    final amountText = isExpense
        ? '-₮${transaction.amount.toInt()}'
        : '+₮${transaction.amount.toInt()}';
    final amountColor = isExpense ? Colors.red : Colors.green;

    return Dismissible(
      key: Key(transaction.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title:
                  const Text('Confirm', style: TextStyle(color: Colors.white)),
              content: const Text(
                  'Are you sure you want to delete this transaction?',
                  style: TextStyle(color: Colors.white70)),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child:
                      const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        Provider.of<TransactionProvider>(context, listen: false)
            .deleteTransaction(transaction);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Transaction deleted'),
            backgroundColor: Colors.grey[800],
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade800)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isExpense ? Icons.arrow_downward : Icons.arrow_upward,
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${transaction.category} • ${_formatDate(transaction.date)}',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              amountText,
              style: TextStyle(
                color: amountColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter by:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Transaction type
          const Text(
            'Transaction Type',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _filterChip('Income', true),
              const SizedBox(width: 8),
              _filterChip('Expense', false),
            ],
          ),

          const SizedBox(height: 24),

          // Date range
          const Text(
            'Date Range',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _filterChip('This Month', true),
              const SizedBox(width: 8),
              _filterChip('Last Month', false),
              const SizedBox(width: 8),
              _filterChip('Custom', false),
            ],
          ),

          const SizedBox(height: 24),

          // Categories
          const Text(
            'Categories',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _filterChip('Shopping', false),
              _filterChip('Food', false),
              _filterChip('Transport', false),
              _filterChip('Entertainment', false),
              _filterChip('Bills', false),
              _filterChip('Salary', false),
            ],
          ),

          const Spacer(),

          // Apply button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Apply filters
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, bool isSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (bool selected) {
        // Handle filter selection
      },
      selectedColor: Colors.blue,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.grey[800],
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
    );
  }

  void _showAddTransactionDialog(BuildContext context) {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    TransactionType transactionType = TransactionType.expense;
    String category = 'Shopping';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Transaction',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[800],
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: amountController,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      border: const OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.grey[800],
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Transaction Type',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Row(
                    children: [
                      Radio<TransactionType>(
                        value: TransactionType.income,
                        groupValue: transactionType,
                        onChanged: (value) {
                          setState(() {
                            transactionType = value!;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      const Text('Income',
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(width: 16),
                      Radio<TransactionType>(
                        value: TransactionType.expense,
                        groupValue: transactionType,
                        onChanged: (value) {
                          setState(() {
                            transactionType = value!;
                          });
                        },
                        activeColor: Colors.blue,
                      ),
                      const Text('Expense',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Category',
                    style: TextStyle(color: Colors.white70),
                  ),
                  DropdownButtonFormField<String>(
                    value: category,
                    items: [
                      'Shopping',
                      'Food',
                      'Transport',
                      'Entertainment',
                      'Bills',
                      'Salary',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        category = newValue!;
                      });
                    },
                    dropdownColor: Colors.grey[800],
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (titleController.text.isNotEmpty &&
                            amountController.text.isNotEmpty) {
                          // Add transaction
                          Provider.of<TransactionProvider>(context,
                                  listen: false)
                              .addTransaction(
                            titleController.text,
                            double.parse(amountController.text),
                            transactionType,
                            category,
                          );
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Add Transaction'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
