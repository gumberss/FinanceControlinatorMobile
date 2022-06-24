import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultDialog {
  showDialog(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            height: 180,
            child: Container(
                decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .canvasColor,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10))),
                child: Column(
                  children: [
                    Text("data"),
                    DefaultInput(
                        "title", TextInputType.text, TextEditingController()),
                    Padding(
                        padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                        child: SizedBox(
                            width: double.maxFinite,
                            child:
                            OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    primary: Colors.green[900],
                                    backgroundColor: Colors.green[100]),
                                onPressed: () {

                                },
                                child: Text("Add"))
                        ))
                  ],
                )),
          );
        });
  }
}
