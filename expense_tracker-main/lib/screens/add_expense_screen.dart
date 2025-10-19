import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart'; // For date formatting
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  // Controllers to get text from input fields
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  DateTime _selectedDate = DateTime.now(); // Default to today

  // A key to identify our form and validate it
  final _formKey = GlobalKey<FormState>();

  // This function will show the date picker
  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  // This function saves the new expense
  void _saveExpense() {
    // Validate the form (check if fields are filled correctly)
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Create a new Expense object
      final newExpense = Expense(
        amount: double.parse(_amountController.text),
        category: _categoryController.text,
        date: _selectedDate,
      );

      // Get a reference to the Hive box and add the new expense
      final box = Hive.box<Expense>('expenses');
      box.add(newExpense);

      // Go back to the previous screen (HomeScreen)
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Expense'),
        backgroundColor: Color(0xFF6A1B9A),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Amount Text Field
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₹ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20), // Add some space

              // Category Text Field
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category (e.g., Food, Travel)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20), // Add some space

              // Date Picker Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 20, color: Colors.deepPurple),
                    const SizedBox(width: 12),
                    Text(
                      'Selected: ${DateFormat('dd MMM yyyy').format(_selectedDate)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(), // Pushes the button to the right
                    TextButton(
                      onPressed: _presentDatePicker,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                      ),
                      child: const Text('Change Date'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A1B94),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Save Expense',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}