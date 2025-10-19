import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class ExpenseChart extends StatelessWidget {
  const ExpenseChart({super.key});

  // Helper function to get the last 7 days
  List<DateTime> _getLast7Days() {
    final today = DateTime.now();
    return List.generate(7, (index) => today.subtract(Duration(days: index)));
  }

  // Calculate total expenses for each of the last 7 days
  Map<DateTime, double> _calculateDailyTotals(Box<Expense> box) {
    final last7Days = _getLast7Days();
    final dailyTotals = <DateTime, double>{};

    // Initialize all days with 0
    for (var day in last7Days) {
      // Normalize to date only (remove time)
      final dateOnly = DateTime(day.year, day.month, day.day);
      dailyTotals[dateOnly] = 0;
    }

    // Calculate actual totals from expenses
    for (var expense in box.values) {
      // Normalize expense date to date only
      final expenseDate = DateTime(expense.date.year, expense.date.month, expense.date.day);

      // Check if this expense is in the last 7 days
      if (dailyTotals.containsKey(expenseDate)) {
        dailyTotals[expenseDate] = dailyTotals[expenseDate]! + expense.amount;
      }
    }

    return dailyTotals;
  }

  // Calculate total for last 7 days
  double _calculate7DayTotal(Box<Expense> box) {
    final dailyTotals = _calculateDailyTotals(box);
    return dailyTotals.values.fold(0, (sum, amount) => sum + amount);
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Expense>('expenses');
    final dailyTotals = _calculateDailyTotals(box);
    final last7Days = _getLast7Days();
    final sevenDayTotal = _calculate7DayTotal(box);

    // Prepare data for the chart
    final barData = last7Days.reversed.map((day) {
      final dateOnly = DateTime(day.year, day.month, day.day);
      final total = dailyTotals[dateOnly] ?? 0;
      return total;
    }).toList();

    return Card(
      margin: const EdgeInsets.all(16),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 7-Day Total in Rupees
            Text(
              'Total Last 7 Days: ₹${sevenDayTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),

            // Chart with daily totals
            SizedBox(
              height: 240,
              child: Column(
                children: [
                  // Daily totals above bars in Rupees
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      return SizedBox(
                        width: 24,
                        child: Text(
                          '₹${barData[index].toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),

                  // Main chart
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: barData.isNotEmpty ? barData.reduce((a, b) => a > b ? a : b) * 1.2 : 100,
                        barGroups: List.generate(7, (index) {
                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: barData[index],
                                color: Colors.deepPurple,
                                width: 16,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final day = last7Days.reversed.toList()[value.toInt()];
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    '${day.day}/${day.month}',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.grey,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}