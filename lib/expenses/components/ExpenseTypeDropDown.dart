import 'package:finance_controlinator_mobile/expenses/domain/ExpenseType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExpenseTypeDropDown extends StatefulWidget {
  String dropdownValue = ExpenseType.types.first.value.toString();

  @override
  State<StatefulWidget> createState() {
    return _DropDown();
  }
}

class _DropDown extends State<ExpenseTypeDropDown> {

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(8),
    child: DropdownButton<String>(
      value: widget.dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      isExpanded:true,
      alignment:  Alignment.center,
      elevation: 16,
      hint: Text("Select a type"),
      style: const TextStyle(color: Colors.deepPurple,),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          widget.dropdownValue = newValue!;
        });
      },
      items: ExpenseType.types
          .map<DropdownMenuItem<String>>((ExpenseType expenseType) {
        return DropdownMenuItem<String>(
          value: expenseType.value.toString(),
          child: new Align(alignment: Alignment.center, child: Text(expenseType.text)),
        );
      }).toList(),
    ),);
  }
}
