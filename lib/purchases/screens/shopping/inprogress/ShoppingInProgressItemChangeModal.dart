import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../components/DefaultInput.dart';

class ShoppingInProgressItemChangeModal extends StatefulWidget {
  ItemChangedData itemData;
  TextEditingController _itemPriceController = TextEditingController();
  TextEditingController _totalPriceController = TextEditingController();

  ShoppingInProgressItemChangeModal(this.itemData);

  @override
  State<ShoppingInProgressItemChangeModal> createState() =>
      _ShoppingInProgressItemChangeModalState();
}

class _ShoppingInProgressItemChangeModalState
    extends State<ShoppingInProgressItemChangeModal> {
  @override
  Widget build(BuildContext context) {

    if (widget.itemData.itemPrice != 0) {
      widget._itemPriceController.text = widget.itemData.itemPrice.toString();
      widget._totalPriceController.text =
          (widget.itemData.itemPrice * widget.itemData.quantityInTheCart)
              .toString();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Banana", style: TextStyle(fontSize: 24)),
                        Text(
                            "Quantity in the cart: ${widget.itemData.quantityInTheCart}",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700])),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                widget.itemData.quantityInTheCart++;
                              });
                            },
                            icon: const Icon(Icons.arrow_upward)),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            width: 2,
                            height: 20,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (widget.itemData.quantityInTheCart > 0) {
                                setState(() {
                                  widget.itemData.quantityInTheCart--;
                                });
                              }
                            },
                            icon: const Icon(Icons.arrow_downward)),
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Expanded(
                            child: DefaultInput(
                          "Item Price",
                          const TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                              widget._itemPriceController,
                          padding: EdgeInsets.zero,
                          hintText: NumberFormat().format(1.50),
                          fontSize: 14,
                          onChanged: (text) {
                            try {
                              var itemPrice = NumberFormat().parse(text);

                              widget._totalPriceController.text = (itemPrice *
                                      widget.itemData.quantityInTheCart)
                                  .toString();


                            } on Exception catch (e) {
                              widget._totalPriceController.text = "0";
                            }
                          },
                        )),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.add)),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            width: 2,
                            height: 20,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.remove)),
                      ],
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                            child: DefaultInput("Total Price",
                                TextInputType.text, widget._totalPriceController,
                                padding: EdgeInsets.zero,
                                fontSize: 14, onChanged: (text) {
                          try {
                            var totalPrice = NumberFormat().parse(text);
                            widget._itemPriceController.text =
                                (totalPrice / widget.itemData.quantityInTheCart)
                                    .toString();

                          } on Exception catch (_) {}
                        },
                                hintText: NumberFormat().format(3.00),)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.add)),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            width: 2,
                            height: 20,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.remove)),
                      ],
                    ))
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    child: Text(AppLocalizations.of(context)!.create),
                    onPressed: () {
                      double itemPrice = NumberFormat()
                          .parse(widget._itemPriceController.text) as double;
                      widget.itemData.itemPrice = itemPrice;

                      Navigator.pop(context, widget.itemData);

                    },
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class ItemChangedData {
  double itemPrice;
  int quantityInTheCart;

  ItemChangedData(this.quantityInTheCart, this.itemPrice);
}
