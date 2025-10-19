import 'package:flutter/material.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/txt.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem(this.expense,{super.key});

  final Expense expense;

  @override
  Widget build(context){
    return Card(
      child:Padding(
        padding: const EdgeInsets.symmetric(
          horizontal:20,
          vertical:16,
        ),
        child: Column(
          children:[
            txt(expense.title,Colors.deepOrangeAccent,25),
            const SizedBox(height:4),
            Row(
              children:[
                txt('₹${expense.amount.toStringAsFixed(2)}',Colors.white60,20),
                const Spacer(),
                Row(
                  children:[
                    Icon(categoryIcons[expense.category]),
                    const SizedBox(width:8),
                    Text(expense.formattedDate),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}