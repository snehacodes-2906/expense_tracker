import 'package:hive/hive.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart'; // for date formatting
import '../models/expense.dart';

class CsvExportService {
  // Export all expenses to CSV format
  static String exportExpensesToCsv(Box<Expense> box) {
    List<List<dynamic>> csvData = [
      // CSV Header row
      ['Amount', 'Category', 'Date']
    ];

    // Add each expense as a new row
    for (var expense in box.values) {
      csvData.add([
        expense.amount,
        expense.category,
        DateFormat('yyyy-MM-dd').format(expense.date), // Format date nicely
      ]);
    }

    // Convert the 2D list to a CSV string
    return const ListToCsvConverter().convert(csvData);
  }

  // Helper method to get expenses for a specific time period (optional)
  static String exportLast30Days(Box<Expense> box) {
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    List<List<dynamic>> csvData = [
      ['Amount', 'Category', 'Date'] // Header
    ];

    for (var expense in box.values) {
      if (expense.date.isAfter(thirtyDaysAgo)) {
        csvData.add([
          expense.amount,
          expense.category,
          DateFormat('yyyy-MM-dd').format(expense.date),
        ]);
      }
    }

    return const ListToCsvConverter().convert(csvData);
  }
}