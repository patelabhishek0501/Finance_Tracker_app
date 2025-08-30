import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: theme.cardColor,
      child: ListTile(
        title: Text(
          transaction.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        subtitle: Text(
          transaction.category,
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),
        trailing: Text(
          '${transaction.isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
          style: TextStyle(
            color: transaction.isIncome ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
