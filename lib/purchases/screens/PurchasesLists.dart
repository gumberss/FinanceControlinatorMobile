import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
            DefaultDialog().showDialog(context)
          },
        ));
  }
}
