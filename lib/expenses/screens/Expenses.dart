import 'dart:io';

import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import 'package:finance_controlinator_mobile/expenses/components/DefaultToast.dart';
import 'package:finance_controlinator_mobile/expenses/components/ExpenseTypeDropDown.dart';
import 'package:finance_controlinator_mobile/expenses/domain/Expense.dart';
import 'package:finance_controlinator_mobile/expenses/domain/ExpenseItem.dart';
import 'package:finance_controlinator_mobile/expenses/domain/ExpenseType.dart';
import 'package:finance_controlinator_mobile/expenses/screens/ExpenseItems.dart';
import 'package:finance_controlinator_mobile/expenses/webclients/ExpenseWebClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

class ExpensesScreen extends StatefulWidget {
  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  TextEditingController _titleController = TextEditingController();

  TextEditingController _descriptionController = TextEditingController();

  TextEditingController _locationController = TextEditingController();

  TextEditingController _totalCostController = TextEditingController();

  TextEditingController _installmentCountController = TextEditingController();

  TextEditingController _purchaseDayController = TextEditingController();

  TextEditingController _typeController = TextEditingController();

  TextEditingController _observationController = TextEditingController();

  List<ExpenseItem> items = List.empty(growable: true);

  FToast toast;

  _ExpensesScreenState() : toast = FToast();

  var typeDropDown = ExpenseTypeDropDown();

  var expenseId = Uuid().v4();

  @override
  Widget build(BuildContext context) {
    toast.init(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Expenses"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  DefaultInput("Title", TextInputType.text, _titleController),
                  DefaultInput("Description", TextInputType.text,
                      _descriptionController),
                  DefaultInput(
                      "Location", TextInputType.text, _locationController),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 5,
                        child: DefaultInput("Total Cost", TextInputType.number,
                            _totalCostController),
                      ),
                      Expanded(
                        flex: 5,
                        child: DefaultInput("Installment Count",
                            TextInputType.number, _installmentCountController),
                      ),
                    ],
                  ),
                  DefaultInput("Purchase Day", TextInputType.text,
                      _purchaseDayController),
                  SizedBox(
                    width: double.maxFinite,
                    child: typeDropDown,
                  ),
                  //DefaultInput("Observation", TextInputType.text, _observationController),
                  Padding(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 4),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              primary: Colors.green[900],
                              backgroundColor: Colors.green[100]),
                          onPressed: () {
                            Navigator.of(context)
                                .push<List<ExpenseItem>>(MaterialPageRoute(
                                    builder: (c) => ExpenseItemsScreen(items)))
                                .then((value) => {
                                      if (value != null)
                                        {
                                          setState(() {
                                            items = value;
                                          })
                                        }
                                    });
                          },
                          child: Text("Items")),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text("Items Details:"),
                      subtitle: Text(
                          "Item Quantity: ${items.length}     Total Cost: ${items.map((e) => e.amount * e.cost).fold<double>(0, (previousValue, element) => previousValue + element)}"),
                    ),
                  )
                ],
              ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
                    child: SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                          onPressed: () async {
                            var title = _titleController.text;
                            var description = _descriptionController.text;
                            var location = _locationController.text;
                            var totalCost =
                                double.tryParse(_totalCostController.text);
                            var installmentsCount =
                                int.tryParse(_installmentCountController.text);
                            var purchaseDay =
                                DateTime.now(); // todo: fix it later
                            var typeInt = int.parse(typeDropDown.dropdownValue);
                            var type = ExpenseType.types
                                .where((element) => element.value == typeInt)
                                .first;

                            if (Expense.areValidProperties(
                                title,
                                description,
                                location,
                                purchaseDay,
                                type,
                                totalCost,
                                installmentsCount,
                                "",
                                items)) {

                              var expense = Expense(expenseId, title, description, location, purchaseDay, type, totalCost!, installmentsCount!, "", items);
                              try{
                                await ExpenseWebClient().save(expense);
                                toast.showToast(
                                  child:
                                  DefaultToast.Success("Expense Created :)"),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 2),
                                );
                                Navigator.pop(context);
                              }on HttpException catch(e){
                                toast.showToast(
                                  child: DefaultToast.Error(
                                      e.message),
                                  gravity: ToastGravity.BOTTOM,
                                  toastDuration: Duration(seconds: 2),
                                );
                              }
                            } else {
                              toast.showToast(
                                child: DefaultToast.Error(
                                    "Ops! Are all fields correct filled?"),
                                gravity: ToastGravity.BOTTOM,
                                toastDuration: Duration(seconds: 2),
                              );
                            }
                          },
                          child: Text("Save")),
                    ),
                  )
                ],
              //DefaultInput("Items", TextInputType.text, _descriptionController),
          ),
        ));
  }
}
