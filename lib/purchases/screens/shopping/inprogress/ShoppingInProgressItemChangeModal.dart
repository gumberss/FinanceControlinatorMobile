import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../domain/shopping/ShoppingItem.dart';
import '../../../../components/DefaultDialog.dart';
import '../../../../components/DefaultInput.dart';

class ShoppingInProgressItemChangeModal extends StatefulWidget {

  ShoppingItem item;

  ShoppingInProgressItemChangeModal(this.item);

  @override
  State<ShoppingInProgressItemChangeModal> createState() =>
      _ShoppingInProgressItemChangeModalState();
}

TextEditingController _itemPriceController = TextEditingController();
TextEditingController _totalPriceController = TextEditingController();

int _quantityInTheCart = 1;

class _ShoppingInProgressItemChangeModalState
    extends State<ShoppingInProgressItemChangeModal> {
  @override
  Widget build(BuildContext context) {
    _itemPriceController.text = "0";
    _totalPriceController.text = "0";
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
                        Text("Quantity in the cart: $_quantityInTheCart",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[700])),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              debugPrint("oi $_quantityInTheCart");
                              setState(() {
                                _quantityInTheCart++;
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
                              if (_quantityInTheCart > widget.item.quantity) {
                                setState(() {
                                  _quantityInTheCart--;
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
                          _itemPriceController,
                          padding: EdgeInsets.zero,
                          fontSize: 14,
                          onChanged: (text) {
                            try {
                              var itemPrice = NumberFormat().parse(text);
                              _totalPriceController.text =
                                  (itemPrice * _quantityInTheCart).toString();
                            } on Exception catch (e) {
                              _totalPriceController.text = "0";
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
                                TextInputType.text, _totalPriceController,
                                padding: EdgeInsets.zero,
                                fontSize: 14, onChanged: (text) {
                          try {
                            var totalPrice = NumberFormat().parse(text);
                            _itemPriceController.text =
                                (totalPrice / _quantityInTheCart).toString();
                          } on Exception catch (_) {}
                        })),
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
                          .parse(_itemPriceController.text) as double;
                      Navigator.pop(context,
                          ItemChangedData(_quantityInTheCart, itemPrice));
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
