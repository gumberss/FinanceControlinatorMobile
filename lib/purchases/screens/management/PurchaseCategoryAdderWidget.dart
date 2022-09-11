import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'dart:math' as math;
import '../../../components/DefaultDialog.dart';
import '../../../components/DefaultInput.dart';

class PurchaseCategoryAdderWidget extends StatefulWidget {
  Future<bool> Function(String title, Color color) onActionDispatched;

  PurchaseCategoryAdderWidget({Key? key, required this.onActionDispatched})
      : super(key: key);

  @override
  State<PurchaseCategoryAdderWidget> createState() =>
      _PurchaseCategoryAdderWidgetState();
}

class _PurchaseCategoryAdderWidgetState
    extends State<PurchaseCategoryAdderWidget> {
  late Color pickerColor;

  _PurchaseCategoryAdderWidgetState() {
    pickerColor = randomColor();
  }

  Widget addCategoryButton() => SizedBox(
        height: 24,
        width: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.only(bottom: 8, right: 16),
                child: const Icon(
                  Icons.category_outlined,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.only(top: 12, left: 12),
                child: const Icon(
                  Icons.add,
                ),
              ),
            ),
          ],
        ),
      );

  Color randomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }

  TextEditingController newPurchaseCategoryNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          changeColor(randomColor());
          DefaultDialog().showDialog(
              context,
              addCategoryWidgets(
                  context,
                  AppLocalizations.of(context)!.purchaseCategoryName,
                  newPurchaseCategoryNameController,
                  widget.onActionDispatched),
              height: 490);
        },
        icon: addCategoryButton());
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
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
        onColorChanged: changeColor,
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
                  child: Text(AppLocalizations.of(context)!.create))))
    ];
  }
}
