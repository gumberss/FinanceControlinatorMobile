import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:math' as math;
import '../../../components/DefaultDialog.dart';
import '../../../components/DefaultInput.dart';

class PurchaseCategoryDialog {
  Future<bool> Function(String title, Color color) onActionDispatched;
  BuildContext context;
  String? title;
  int? color;
  late Color pickerColor;
  late bool existent;

  PurchaseCategoryDialog(
      {required this.context,
      required this.onActionDispatched,
      this.title,
      this.color}) {
    pickerColor = color == null ? randomColor() : Color(color!);
    if (title != null) {
      newPurchaseCategoryNameController.text = title!;
      existent = true;
    }else{
      existent = false;
    }
  }

  Color randomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }

  TextEditingController newPurchaseCategoryNameController =
      TextEditingController();

  void showDialog() {
    DefaultDialog().showDialog(
        context,
        addCategoryWidgets(
            context,
            AppLocalizations.of(context)!.purchaseCategoryName,
            newPurchaseCategoryNameController,
            onActionDispatched),
        height: 490);
  }

  List<Widget> addCategoryWidgets(
      BuildContext context,
      String label,
      TextEditingController controller,
      Future<bool> Function(String title, Color color) action) {
    return [
      HueRingPicker(
        pickerColor: pickerColor,
        displayThumbColor: true,
        enableAlpha: false,
        onColorChanged: (color) {
          pickerColor = color;
        },
      ),
      DefaultInput(label, TextInputType.text, controller),
      Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: SizedBox(
              width: double.maxFinite,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      primary: Colors.green[900],
                      backgroundColor: Colors.green[100]),
                  onPressed: () async {
                    if (controller.text.isEmpty) {
                      //todo: toast error
                      return;
                    }

                    try {
                      var result = await action(controller.text, pickerColor);
                      if (result) {
                        //todo: toast success
                        controller.clear();
                        Navigator.pop(context);
                      } else {
                        //todo: toast error
                      }
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                      //todo: toast error
                    }
                  },
                  child: existent
                      ? Text(AppLocalizations.of(context)!.edit)
                      : Text(AppLocalizations.of(context)!.create))))
    ];
  }
}
