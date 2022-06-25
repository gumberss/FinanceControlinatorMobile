import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finance_controlinator_mobile/components/DefaultInput.dart';


import '../../components/DefaultDialog.dart';

class PurchasesListsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Purchases Lists"), //from dto
        ),
        body: Text("Body"),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add),
          onPressed: () => {
            DefaultDialog().showDialog(context, [
              Text("data"),
              DefaultInput(
                  "title", TextInputType.text, TextEditingController()),
              Padding(
                  padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                  child: SizedBox(
                      width: double.maxFinite,
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              primary: Colors.green[900],
                              backgroundColor: Colors.green[100]),
                          onPressed: () {},
                          child: Text("Add"))))
            ])
          },
        ));
  }
}
