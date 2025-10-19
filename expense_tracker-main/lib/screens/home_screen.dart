import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';
import '../services/csv_export.dart';
import '../widgets/chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _addNewExpense(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AddExpenseScreen(),
      ),
    );
  }

  void _exportToCsv(BuildContext context) {
    final box = Hive.box<Expense>('expenses');

    if (box.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No expenses to export!')),
      );
      return;
    }

    final csvString = CsvExportService.exportExpensesToCsv(box);
    Clipboard.setData(ClipboardData(text: csvString));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CSV data copied to clipboard!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCE4EC),
      body: StreamBuilder(
        stream: Hive.box<Expense>('expenses').watch(),
        builder: (context, snapshot) {
          final box = Hive.box<Expense>('expenses');
          final total = box.values.isEmpty
              ? 0
              : box.values
              .map((expense) => expense.amount)
              .reduce((a, b) => a + b);

          return CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: const Text(
                  'Your Expenses',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.download, color: Color(0xFF6A1B9A)),
                    onPressed: () => _exportToCsv(context),
                  ),
                ],
              ),

              // Total Card
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE1BEE7), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          'Total Spent',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF6A1B9A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6A1B9A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Chart Section
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE1BEE7), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: ExpenseChart(),
                  ),
                ),
              ),

              // Expenses List Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                  child: Text(
                    'Recent Expenses (${box.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A1B9A),
                    ),
                  ),
                ),
              ),

              // Expenses List
              // Expenses List - SORTED BY DATE
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    // Get all expenses and sort by date (newest first)
                    final allExpenses = box.values.toList();
                    allExpenses.sort((a, b) => b.date.compareTo(a.date)); // Newest first

                    final expense = allExpenses[index];

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFE1BEE7), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purple.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1BEE7).withOpacity(0.3),
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFAB47BC), width: 1.5),
                          ),
                          child: const Icon(Icons.currency_rupee, size: 22, color: Color(0xFF6A1B9A)),
                        ),
                        title: Text(
                          '₹${expense.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6A1B9A),
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text(
                          expense.category,
                          style: TextStyle(
                            color: const Color(0xFF6A1B9A).withOpacity(0.7),
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateFormat('MMM d').format(expense.date),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6A1B9A),
                              ),
                            ),
                            Text(
                              DateFormat('EEE').format(expense.date),
                              style: TextStyle(
                                fontSize: 12,
                                color: const Color(0xFF6A1B9A).withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: box.length, // Still use box.length for total count
                ),
              ),
            ],
          );
        },
      ),

      // FAB - FIXED THE TYPO HERE
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewExpense(context),
        backgroundColor: const Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
        shape: const CircleBorder(), // ← FIXED: Changed from RoundedCircleBorder to CircleBorder
        child: const Icon(Icons.add),
      ),
    );
  }
}