import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultInput extends StatelessWidget {
  String title;
  TextInputType type;
  TextEditingController controller;

  bool obscureText;

  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;
  AutovalidateMode autoValidateMode;

  DefaultInput(this.title, this.type, this.controller,
      {this.obscureText = false,
      this.validator,
      this.onChanged,
      this.autoValidateMode = AutovalidateMode.onUserInteraction});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
        child: TextFormField(
          obscureText: obscureText,
          controller: controller,
          onChanged: onChanged,
          autovalidateMode: autoValidateMode,
          decoration: InputDecoration(
              labelText: title,
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
              )),
          style: TextStyle(fontSize: 16.0),
          keyboardType: type,
          validator: validator,
        ));
  }
}
