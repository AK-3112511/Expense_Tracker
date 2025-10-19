import'package:flutter/material.dart';  
import 'package:expense_tracker/txt.dart';
import 'package:expense_tracker/models/expense.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key,required this.onAddExpense});

  final void Function(Expense expense) onAddExpense;

  @override
  State<NewExpense> createState(){
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense>{

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.food;

  void _datePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year-1,now.month,now.day);

    final pickedDate = await showDatePicker(
      context: context, 
      initialDate:now,
      firstDate: firstDate, 
      lastDate: now,
    );
    setState((){
      _selectedDate = pickedDate;
    });
  }

  void _submitExpense() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount==null || enteredAmount<=0;
    if(_titleController.text.trim().isEmpty || amountIsInvalid ||  _selectedDate==null){
      showDialog(
        context: context, 
        builder: (ctx)=> AlertDialog(
          title:txt('Invalid input',Colors.red,20),
          content: const Text('please enter valid title,amount or date'),
          actions:[
            TextButton(
              onPressed: (){
                Navigator.pop(ctx);
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(Expense(title:_titleController.text, amount: enteredAmount, date: _selectedDate!, category: _selectedCategory));
    Navigator.pop(context);
  }

  @override
  void dispose(){
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(context){
    return Padding(
      padding: EdgeInsets.all(16),
      child:Column(
        children:[
          TextField(
            controller:_titleController,
            maxLength: 30,
            decoration: InputDecoration(
              label: Text('Title'),
            ),
          ),
          Row(
            children:[
              Expanded(
                child: TextField(
                  controller:_amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText:'₹ ',
                    label: Text('Amount'),
                  ),
                ),
              ),

              const SizedBox(width:16),

              Expanded(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children:[
                    Expanded(child: txt(_selectedDate==null ? 'No Date selected' : formatter.format(_selectedDate!),const Color.fromARGB(255, 68, 99, 114),15)),
                    IconButton(
                      onPressed:_datePicker,
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height:16),
          Row(
            children:[
              DropdownButton(
                value:_selectedCategory,
                items: Category.values.map(
                  (category)=>DropdownMenuItem(
                    value :category,
                    child: Text(category.name.toUpperCase()),
                  ),
                ).toList(), 
                onChanged: (value){
                  if (value ==null){
                    return;
                  }
                  setState((){
                    _selectedCategory = value;
                  });
                },
              ),
              const Spacer(),
              TextButton(
                onPressed:(){
                  Navigator.pop(context);
                },
                child: txt('Cancel',const Color.fromARGB(212, 195, 42, 31),15)
              ),
              ElevatedButton(
                onPressed: _submitExpense,
                child: txt('Save Expense',const Color.fromARGB(202, 7, 142, 12),15),
              ),
            ],
          ),
        ],
      ),
    );
  }
}