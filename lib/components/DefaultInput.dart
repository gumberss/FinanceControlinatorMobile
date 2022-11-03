import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DefaultInput extends StatelessWidget {
  String title;
  TextInputType type;
  TextEditingController controller;
  bool autoFocus;
  bool obscureText;
  Function? onSubmitted;
  FormFieldValidator<String>? validator;
  ValueChanged<String>? onChanged;
  AutovalidateMode autoValidateMode;
  String? hintText;
  EdgeInsets padding;
  double fontSize;

  DefaultInput(this.title, this.type, this.controller,
      {this.obscureText = false,
      this.autoFocus = false,
      this.onSubmitted,
      this.validator,
      this.onChanged,
      this.hintText,
      this.autoValidateMode = AutovalidateMode.onUserInteraction,
      this.padding =
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 2.0, bottom: 2.0),
      this.fontSize = 16.0});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding,
        child: TextFormField(
          onEditingComplete: () {
            if (onSubmitted != null) {
              onSubmitted!();
            }
          },
          autofocus: autoFocus,
          obscureText: obscureText,
          controller: controller,
          onChanged: onChanged,
          autovalidateMode: autoValidateMode,
          decoration: InputDecoration(
              labelText: title,
              hintText: hintText ?? "",
              errorBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
              )),
          style: TextStyle(fontSize: fontSize),
          keyboardType: type,
          validator: validator,
        ));
  }
}
