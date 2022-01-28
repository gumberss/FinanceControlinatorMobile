import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpensesScreen extends StatelessWidget {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  TextEditingController _locationController = TextEditingController();
  TextEditingController _totalCostController = TextEditingController();
  TextEditingController _installmentCountController = TextEditingController();
  TextEditingController _purchaseDayController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _observationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Expenses"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DefaultInput("Title", TextInputType.text, _titleController),
                DefaultInput(
                    "Description", TextInputType.text, _descriptionController),
                DefaultInput(
                    "Location", TextInputType.text, _locationController),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: DefaultInput("Total Cost", TextInputType.number,
                        _totalCostController),),
                    Expanded(
                      flex: 5,
                      child: DefaultInput("Installment Count", TextInputType.number,
                        _installmentCountController),),
                  ],
                ),
                DefaultInput(
                    "Purchase Day", TextInputType.text, _purchaseDayController),
                DefaultInput("Type", TextInputType.text, _typeController),
                //DefaultInput("Observation", TextInputType.text, _observationController),
                Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 4),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: Colors.green[900],
                            backgroundColor: Colors.green[100]),
                        onPressed: () {},
                        child: Text("Items")),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 8),
                  child: SizedBox(
                    width: double.maxFinite,
                    child:
                        ElevatedButton(onPressed: () {}, child: Text("Save")),
                  ),
                )
              ],
            )
            //DefaultInput("Items", TextInputType.text, _descriptionController),
          ],
        ));
  }
}
