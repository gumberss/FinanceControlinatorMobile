import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../domain/shopping/ShoppingItem.dart';
import '../../../../components/DefaultDialog.dart';
import '../../../../components/DefaultInput.dart';
import 'ShoppingInProgressItemChangeModal.dart';

class ShoppingInProgressItemWidget extends StatefulWidget {
  ShoppingItem item;

  ShoppingInProgressItemWidget(this.item, {Key? key}) : super(key: key);

  @override
  State<ShoppingInProgressItemWidget> createState() =>
      _ShoppingInProgressItemWidgetState();
}

class _ShoppingInProgressItemWidgetState
    extends State<ShoppingInProgressItemWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      //leading: Image.network(i.urlImage,width: 40, height: 40, fit: BoxFit.cover),
      title: Text(widget.item.name),
      subtitle: Text(AppLocalizations.of(context)!.amountToBuy +
          widget.item.quantity.toString()),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  showDialog(context)
                  .then((value){
                    if(value == null) return;
                    setState((){
                      widget.item.quantity -= value.quantityInTheCart;
                    });
                  });
                },
                icon: const Icon(Icons.check)),
          ],
        ),
      ),
    );
  }

  Future<ItemChangedData?> showDialog(BuildContext context) async {
    return await DefaultDialog().showDialogScreen<ItemChangedData>(
        context, ShoppingInProgressItemChangeModal(widget.item),
        height: 260, mainAlignment: MainAxisAlignment.spaceBetween);
  }
}
