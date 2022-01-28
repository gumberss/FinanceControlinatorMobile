import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseType {
  String text;
  int value;

  ExpenseType(this.text, this.value);

  static List<ExpenseType> Types = [
    ExpenseType("Market", 0),
    ExpenseType("Bill", 10),
    ExpenseType("Leisure", 20),
    ExpenseType("Investment", 30),
    ExpenseType("Health", 40),
    ExpenseType("Other", 900),
  ];
}
