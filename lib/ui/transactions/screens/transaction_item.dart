import 'package:flutter/material.dart';
import '../../../domain/entities/transaction.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  final Transaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final sign = isIncome ? '+' : '-';
    final color = isIncome ? Colors.green : Colors.red;

    return ListTile(
      onTap: onTap,
      leading: Icon(
        isIncome ? Icons.arrow_downward : Icons.arrow_upward,
        color: color,
      ),
      title: Text(transaction.category),
      subtitle: Text(
        transaction.note != null && transaction.note!.isNotEmpty
            ? '${transaction.note} • ${_formatDate(transaction.date)}'
            : _formatDate(transaction.date),
      ),
      trailing: Text(
        '$sign${transaction.amount.toStringAsFixed(2)} ₽',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: color,
          fontSize: 16,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}


