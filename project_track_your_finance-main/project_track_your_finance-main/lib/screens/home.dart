import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_track_your_finance/screens/about_screen.dart';
import 'package:project_track_your_finance/screens/analytics_card.dart';
import 'package:provider/provider.dart';
import '../providers/transaction_provider.dart';
import '../models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        middle: const Text('Finance Tracker', style: TextStyle(color: CupertinoColors.label, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // CupertinoButton(
            //   padding: EdgeInsets.zero,
            //   onPressed: _showFilterOptions,
            //   child: const Icon(CupertinoIcons.line_horizontal_3_decrease_circle, color: CupertinoColors.activeBlue, size: 20),
            // ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => AboutScreen()),
                );
              },
              child: const Icon(CupertinoIcons.info_circle, color: CupertinoColors.activeBlue, size: 20),
            ),
          ],
        ),
      ),
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          final transactions = transactionProvider.transactions
              .where((t) => _selectedCategory == 'All' || t.category == _selectedCategory)
              .toList();

          final double totalIncome = transactions.where((t) => t.isIncome).fold(0, (sum, t) => sum + t.amount);
          final double totalExpenses = transactions.where((t) => !t.isIncome).fold(0, (sum, t) => sum + t.amount);
          final double balance = totalIncome - totalExpenses;

          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ExpenseTrackerCard(
                    totalIncome: totalIncome,
                    totalExpenses: totalExpenses,
                    balance: balance,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Transactions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 57, 57, 57))),
                        CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _showFilterOptions,
                        child: Row(
                          children: const [
                          Icon(CupertinoIcons.line_horizontal_3_decrease_circle, color: CupertinoColors.activeBlue, size: 16),
                          SizedBox(width: 4),
                          Text('Filter', style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 16)),
                          ],
                        ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: transactions.isEmpty
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.chevron_up_chevron_down, color: CupertinoColors.inactiveGray, size: 40),
                              Text("No transactions found!", style: TextStyle(fontSize: 16, color: CupertinoColors.inactiveGray, fontWeight: FontWeight.normal)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: transactions.length,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return _buildTransactionCard(transaction, context);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTransactionCard(Transaction transaction, BuildContext context) {
    return Card(
      color: CupertinoColors.white,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: transaction.isIncome ? CupertinoColors.activeGreen : CupertinoColors.systemRed,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                transaction.isIncome ? CupertinoIcons.arrow_down : CupertinoIcons.arrow_up,
                color: CupertinoColors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: CupertinoColors.black),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${transaction.category} • ${DateFormat('dd MMM yyyy').format(transaction.date)}',
                    style: const TextStyle(color: CupertinoColors.inactiveGray, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(
              '₹${transaction.amount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: transaction.isIncome ? CupertinoColors.activeGreen : CupertinoColors.systemRed,
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              child: const Icon(CupertinoIcons.ellipsis, color: CupertinoColors.inactiveGray, size: 20),
              onPressed: () => _showTransactionOptions(transaction),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransactionOptions(Transaction transaction) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text(transaction.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
          message: const Text('Choose an action for this transaction', style: TextStyle(fontSize: 14)),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                showUpdateTransactionSheet(context, transaction);
              },
              child: const Text('Edit', style: TextStyle(fontSize: 14)),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                _deleteTransaction(transaction.id!);
              },
              isDestructiveAction: true,
              child: const Text('Delete', style: TextStyle(fontSize: 14)),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 14, color: CupertinoColors.systemBlue)),
          ),
        );
      },
    );
  }

  void _deleteTransaction(int transactionId) {
    Provider.of<TransactionProvider>(context, listen: false).deleteTransaction(transactionId);
  }

  void _showFilterOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: const Text('Select Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
          actions: ['All', 'Food', 'Transport', 'Shopping', 'Bills']
              .map(
                (category) => CupertinoActionSheetAction(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                    Navigator.pop(context);
                  },
                  child: Text(category, style: const TextStyle(fontSize: 14)),
                ),
              )
              .toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontSize: 14, color: CupertinoColors.systemBlue)),
          ),
        );
      },
    );
  }
}

void showUpdateTransactionSheet(BuildContext context, Transaction transaction) {
  TextEditingController nameController = TextEditingController(text: transaction.name);
  TextEditingController amountController = TextEditingController(text: transaction.amount.toString());
  String selectedCategory = transaction.category;

  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return CupertinoActionSheet(
            title: const Text("Update Transaction", style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
            message: Column(
              children: [
                CupertinoTextField(
                  controller: nameController,
                  placeholder: "Transaction Name",
                  padding: const EdgeInsets.all(12),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: amountController,
                  placeholder: "Amount",
                  padding: const EdgeInsets.all(12),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) {
                        return CupertinoActionSheet(
                          title: const Text('Select Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                          actions: ['Food', 'Transport', 'Shopping', 'Bills', 'Other']
                              .map(
                                (category) => CupertinoActionSheetAction(
                                  onPressed: () {
                                    setState(() {
                                      selectedCategory = category;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Text(category, style: const TextStyle(fontSize: 14)),
                                ),
                              )
                              .toList(),
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel', style: TextStyle(fontSize: 14, color: CupertinoColors.systemBlue)),
                          ),
                        );
                      },
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CupertinoIcons.tag, size: 16),
                      const SizedBox(width: 8),
                      Text(selectedCategory, style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () {
                  final updatedTransaction = Transaction(
                    id: transaction.id,
                    name: nameController.text,
                    amount: double.parse(amountController.text),
                    category: selectedCategory,
                    isIncome: transaction.isIncome,
                    date: transaction.date,
                  );

                  Provider.of<TransactionProvider>(context, listen: false).updateTransaction(updatedTransaction);
                  Navigator.pop(context);
                },
                child: const Text('Update', style: TextStyle(fontSize: 14)),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(fontSize: 14, color: CupertinoColors.systemBlue)),
            ),
          );
        },
      );
    },
  );
}
