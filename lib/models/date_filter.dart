import 'package:expense_tracker/models/expense.dart';

enum FilterType { allTime, custom }

enum ChartType { bar, pie }

class DateFilter {
  DateFilter({
    this.filterType = FilterType.allTime,
    this.chartType = ChartType.bar,
    this.startDate,
    this.endDate,
  });

  final FilterType filterType;
  final ChartType chartType;
  final DateTime? startDate;
  final DateTime? endDate;

  // Filter expenses based on date range
  List<Expense> filterExpenses(List<Expense> expenses) {
    if (filterType == FilterType.allTime) {
      return expenses;
    }

    if (startDate == null || endDate == null) {
      return expenses;
    }

    return expenses.where((expense) {
      // Normalize expense date to start of day for comparison
      final expenseDate = DateTime(
        expense.date.year,
        expense.date.month,
        expense.date.day,
      );
      
      // Normalize start date to start of day
      final start = DateTime(
        startDate!.year,
        startDate!.month,
        startDate!.day,
      );
      
      // Normalize end date to start of day (we'll do inclusive comparison)
      final end = DateTime(
        endDate!.year,
        endDate!.month,
        endDate!.day,
      );

      // Check if expense date is within range (inclusive on both ends)
      return (expenseDate.isAtSameMomentAs(start) || expenseDate.isAfter(start)) &&
             (expenseDate.isAtSameMomentAs(end) || expenseDate.isBefore(end));
    }).toList();
  }

  // Create a copy with updated values
  DateFilter copyWith({
    FilterType? filterType,
    ChartType? chartType,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return DateFilter(
      filterType: filterType ?? this.filterType,
      chartType: chartType ?? this.chartType,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}