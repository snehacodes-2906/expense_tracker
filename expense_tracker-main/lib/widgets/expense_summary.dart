import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';

class ExpenseSummary extends StatelessWidget {
  final List<Expense> expenses;
  final DateTime startDate;
  final DateTime endDate;

  const ExpenseSummary({
    super.key,
    required this.expenses,
    required this.startDate,
    required this.endDate,
  });

  double get totalAmount => expenses.fold(0, (sum, expense) => sum + expense.amount);

  Map<String, double> get categoryTotals {
    final totals = <String, double>{};
    for (var expense in expenses) {
      totals.update(
        expense.category,
            (value) => value + expense.amount,
        ifAbsent: () => expense.amount,
      );
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');
    final numberFormat = NumberFormat.currency(symbol: '₹');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Total Expenses
        ListTile(
          leading: const Icon(Icons.account_balance_wallet, color: Colors.green, size: 30),
          title: const Text('Total Expenses', style: TextStyle(fontWeight: FontWeight.bold)),
          trailing: Text(
            numberFormat.format(totalAmount),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
          ),
        ),

        // Category Breakdown
        if (categoryTotals.isNotEmpty) ...[
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Where you spent:', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ...categoryTotals.entries.map((entry) => ListTile(
            leading: const Icon(Icons.category, color: Colors.blue, size: 24),
            title: Text(entry.key),
            trailing: Text(numberFormat.format(entry.value)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            visualDensity: const VisualDensity(vertical: -3),
          )),
        ],

        // Date Range Info
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Period: ${dateFormat.format(startDate)} - ${dateFormat.format(endDate)}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}