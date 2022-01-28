import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultInput extends StatelessWidget{
  String title;
  TextInputType type;
  TextEditingController controller;

  DefaultInput(this.title, this.type, this.controller);

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: EdgeInsets.only(left:  8.0, right: 8.0, top: 2.0, bottom: 2.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: title),
          style: TextStyle(fontSize: 16.0),
          keyboardType: type,
        ));
  }
}