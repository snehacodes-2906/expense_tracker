import 'package:hive/hive.dart';

part 'expense.g.dart'; // This file will be generated

@HiveType(typeId: 0) // Unique ID for Hive
class Expense {
  @HiveField(0)
  final double amount;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final DateTime date;

  Expense({
    required this.amount,
    required this.category,
    required this.date,
  });
}