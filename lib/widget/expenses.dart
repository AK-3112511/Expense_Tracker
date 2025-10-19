import 'package:flutter/material.dart';
import 'package:expense_tracker/txt.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/models/date_filter.dart';
import 'package:expense_tracker/widget/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widget/new_expense.dart';
import 'package:expense_tracker/widget/chart/chart.dart';
import 'package:expense_tracker/widget/chart/pie_chart.dart';
import 'package:expense_tracker/widget/date_range_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState(){
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses>{
  final List<Expense> _registeredExpenses = [];
  DateFilter _currentFilter = DateFilter();

  @override
  void initState(){
    super.initState();
    _loadExpenses();
  }

  void _loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final String? expensesJson = prefs.getString('expenses');
    
    if(expensesJson != null){
      final List<dynamic> decoded = jsonDecode(expensesJson);
      setState((){
        _registeredExpenses.clear();
        for(var item in decoded){
          _registeredExpenses.add(Expense(
            title: item['title'],
            amount: item['amount'],
            date: DateTime.parse(item['date']),
            category: Category.values[item['category']],
          ));
        }
      });
    }
  }

  void _saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> expensesList = _registeredExpenses.map((e) => {
      'title': e.title,
      'amount': e.amount,
      'date': e.date.toIso8601String(),
      'category': e.category.index,
    }).toList();
    
    await prefs.setString('expenses', jsonEncode(expensesList));
  }

  void _addExpense(){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx)=>NewExpense(onAddExpense: _displayExpense),
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DateRangeSelector(
        currentFilter: _currentFilter,
        onApply: (newFilter) {
          setState(() {
            _currentFilter = newFilter;
          });
        },
      ),
    );
  }

  void _displayExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
    _saveExpenses();
  }

  void _removeExpense(Expense expense){
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    _saveExpenses();
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration:Duration(seconds:3),
        content:const txt("Expense deleted!",Color.fromARGB(255, 220, 47, 47),20),
        action:SnackBarAction(
          label: 'Undo', 
          onPressed: (){
            setState(() {
              _registeredExpenses.insert(expenseIndex,expense);
            });
            _saveExpenses();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    // Filter expenses based on current filter
    final filteredExpenses = _currentFilter.filterExpenses(_registeredExpenses);

    Widget mainContent = Center(
      child:Text(
        'No Expenses found!',
        style:GoogleFonts.poppins(
          color: Color.fromARGB(255, 255, 232, 161),
          fontSize:30,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    if(filteredExpenses.isNotEmpty){
      mainContent = ExpensesList(
        expenses:filteredExpenses,
        onRemoveExpense: _removeExpense,
      );
    } else if (_registeredExpenses.isNotEmpty && filteredExpenses.isEmpty) {
      mainContent = const Center(
        child:txt('No expenses in selected date range',Color.fromARGB(255, 179, 176, 8),20),
      );
    }

    // Choose chart based on filter
    Widget chartWidget;
    if (_currentFilter.chartType == ChartType.bar) {
      chartWidget = Chart(expenses: filteredExpenses);
    } else {
      chartWidget = PieChart(expenses: filteredExpenses);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Expense Tracker",
          style:GoogleFonts.montserrat(
            color:Color.fromARGB(255, 79, 195, 247),
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions:[
          // Filter button with indicator
          Stack(
            children: [
              IconButton(
                onPressed: _openFilterSheet,
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filter & Chart Options',
              ),
              if (_currentFilter.filterType == FilterType.custom)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            onPressed: _addExpense,
            icon: const Icon(Icons.add),
            tooltip: 'Add Expense',
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children:[
          chartWidget,
          Expanded(
            child:mainContent,
          ),
        ],
      ),
    );
  }
}