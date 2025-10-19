import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String label;

  const DatePicker({
    super.key,
    this.selectedDate,
    required this.onDateSelected,
    required this.label,
  });

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: const BoxConstraints(minWidth: 120), // Add minimum width
        child: Row(
          mainAxisSize: MainAxisSize.min, // Changed to min
          mainAxisAlignment: MainAxisAlignment.center, // Center content
          children: [
            const Icon(Icons.calendar_today, size: 20),
            const SizedBox(width: 8),
            Expanded( // Wrap text in Expanded to prevent overflow
              child: Text(
                selectedDate != null
                    ? DateFormat('dd MMM').format(selectedDate!) // Shorter format
                    : 'Select $label',
                style: const TextStyle(fontSize: 12), // Smaller font
                overflow: TextOverflow.ellipsis, // Handle overflow gracefully
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}