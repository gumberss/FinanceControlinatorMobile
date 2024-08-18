import 'package:flutter/material.dart';
import 'package:finance_controlinator_mobile/purchases/screens/management/PurchaseCategoryDialog.dart';

class PurchaseCategoryAdderWidget extends StatelessWidget {
  Future<bool> Function(String title, Color color) onActionDispatched;
  Color? pickerColor;

  PurchaseCategoryAdderWidget(
      {super.key, required this.onActionDispatched});


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

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){
      PurchaseCategoryDialog(
          context: context,
          onActionDispatched: onActionDispatched).showDialog();
    }, icon: addCategoryButton());
  }
}
