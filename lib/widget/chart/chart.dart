import 'package:flutter/material.dart';
import 'package:expense_tracker/widget/chart/chart_bar.dart';
import 'package:expense_tracker/models/expense.dart';

class Chart extends StatelessWidget {
  const Chart({super.key, required this.expenses});

  final List<Expense> expenses;

  List<ExpenseBucket> get buckets {
    return [
      ExpenseBucket.forCategory(expenses, Category.food),
      ExpenseBucket.forCategory(expenses, Category.moneylent),
      ExpenseBucket.forCategory(expenses, Category.grocery),
      ExpenseBucket.forCategory(expenses, Category.travel),
      ExpenseBucket.forCategory(expenses, Category.others),
    ];
  }

  double get maxTotalExpense {
    double maxTotalExpense = 0;
    for (final bucket in buckets) {
      if (bucket.totalExpenses > maxTotalExpense) {
        maxTotalExpense = bucket.totalExpenses;
      }
    }
    return maxTotalExpense == 0 ? 100 : maxTotalExpense;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            isDarkMode
                ? Colors.grey[850]!
                : Colors.blue[50]!,
            isDarkMode
                ? Colors.grey[900]!
                : Colors.indigo[100]!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withOpacity(0.3)
                : Colors.indigo.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              'Spending Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.indigo[900],
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < buckets.length; i++)
                  ChartBar(
                    fill: buckets[i].totalExpenses == 0
                        ? 0
                        : buckets[i].totalExpenses / maxTotalExpense,
                    amount: buckets[i].totalExpenses,
                    category: buckets[i].category,
                  )
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (final bucket in buckets)
                Expanded(
                  child: Column(
                    children: [
                      Icon(
                        categoryIcons[bucket.category],
                        size: 24,
                        color: _getCategoryColor(bucket.category),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        bucket.category.name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode
                              ? Colors.grey[300]
                              : Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.food:
        return Colors.red[400]!;
      case Category.travel:
        return Colors.blue[400]!;
      case Category.grocery:
        return Colors.green[400]!;
      case Category.moneylent:
        return Colors.orange[400]!;
      case Category.others:
        return Colors.purple[400]!;
    }
  }
}