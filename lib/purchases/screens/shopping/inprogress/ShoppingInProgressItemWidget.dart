import 'package:finance_controlinator_mobile/purchases/domain/shopping/cart/events/ChangeItemEvent.dart';
import 'package:finance_controlinator_mobile/purchases/domain/services/ColorService.dart';
import 'package:finance_controlinator_mobile/purchases/webclients/shopping/CartEventWebClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../domain/shopping/ShoppingItem.dart';
import '../../../../components/DefaultDialog.dart';
import '../../../../components/DefaultInput.dart';
import 'ShoppingInProgressItemChangeModal.dart';

class ShoppingInProgressItemWidget extends StatefulWidget {
  ShoppingItem item;
  String shoppingId;
  Function onError;

  ShoppingInProgressItemWidget(this.shoppingId, this.item, this.onError,
      {Key? key})
      : super(key: key);

  @override
  State<ShoppingInProgressItemWidget> createState() =>
      _ShoppingInProgressItemWidgetState();
}

class _ShoppingInProgressItemWidgetState
    extends State<ShoppingInProgressItemWidget> {
  @override
  Widget build(BuildContext context) {
    var remainingQuantity = (widget.item.quantity - widget.item.quantityInCart);
    return ListTile(
      //leading: Image.network(i.urlImage,width: 40, height: 40, fit: BoxFit.cover),
      title: Text(widget.item.name),
      subtitle: Text(
        AppLocalizations.of(context)!.amountToBuy +
            (widget.item.quantity - widget.item.quantityInCart).toString(),
        style: TextStyle(
            color: ColorService.colorByRemainingQuantity(remainingQuantity)),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 24),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () {
                  showDialog(context).then((value) async {
                    if (value == null) return;
                    var oldQuantityInCart = widget.item.quantityInCart;
                    var newQuantityInCart = value.quantityInTheCart;
                    setState(() {
                      widget.item.quantityInCart = newQuantityInCart;
                      widget.item.price = value.itemPrice;
                    });
                    var amountChanged = newQuantityInCart - oldQuantityInCart;
                    var changeItemEvent = ChangeItemEvent(Uuid().v4(), widget.shoppingId,
                        widget.item.id!, value.itemPrice, amountChanged);

                    var result = await CartEventWebClient()
                        .sendChangeItemEvent(changeItemEvent);

                    if (!result.success()) {
                      widget.onError();
                    }
                    // todo: check if there is a new event and update the list if yes
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
        context,
        ShoppingInProgressItemChangeModal(ItemChangedData(widget.item.name, widget.item.quantity,
            widget.item.quantityInCart, widget.item.price)),
        height: 260,
        mainAlignment: MainAxisAlignment.spaceBetween);
  }
}
