import 'package:flutter/material.dart';
import 'package:expense_tracker/widget/expenses.dart';

var kColorScheme = ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 96, 59, 181));

var kDarkColorScheme = ColorScheme.fromSeed(brightness:Brightness.dark,seedColor:const Color.fromARGB(255, 5, 99, 125));

void main(){
  runApp(
    MaterialApp(
      darkTheme:ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: kDarkColorScheme,
      ),
      theme:ThemeData().copyWith(
        useMaterial3:true,
        colorScheme: kColorScheme,
        appBarTheme: AppBarTheme().copyWith(
          foregroundColor:kColorScheme.onPrimaryContainer,
        ),
        cardTheme: CardThemeData().copyWith(
          color:kDarkColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(horizontal:16,vertical:8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kDarkColorScheme.primaryContainer,
          ),
        ),
      ),
      //themeMode:ThemeMode.system,//
      home:Expenses(
      ),
    ),
  );
}
