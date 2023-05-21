import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../components/DefaultInput.dart';
import '../../../../l10n/i10n.dart';
import '../../../domain/services/ColorService.dart';

class ShoppingInProgressItemChangeModal extends StatefulWidget {
  ItemChangedData itemData;
  TextEditingController _itemPriceController = TextEditingController();
  TextEditingController _totalPriceController = TextEditingController();

  final CurrencyTextInputFormatter _itemPriceCurrencyFormater =
      CurrencyTextInputFormatter(locale: i10n.getCurrentLocale());

  final CurrencyTextInputFormatter _totalPriceCurrencyFormater =
      CurrencyTextInputFormatter(locale: i10n.getCurrentLocale());

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
      widget._itemPriceController.text = widget._itemPriceCurrencyFormater
          .format(widget.itemData.itemPrice.toString());
      widget._totalPriceController.text = widget._totalPriceCurrencyFormater
          .format(
              (widget.itemData.itemPrice * widget.itemData.quantityInTheCart)
                  .toString());
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
                        Text(widget.itemData.itemName,
                            style: TextStyle(fontSize: 24)),
                        Text(
                            "${AppLocalizations.of(context)!.expected}: ${widget.itemData.expectedQuantity}    ${AppLocalizations.of(context)!.inTheCart}: ${widget.itemData.quantityInTheCart}",
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorService.colorByRemainingQuantity(
                                    widget.itemData.expectedQuantity -
                                        widget.itemData.quantityInTheCart))),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              setState(() {
                                widget.itemData.quantityInTheCart++;
                              });

                              var itemPrice = widget._itemPriceCurrencyFormater
                                  .getUnformattedValue();

                              try {
                                if (!itemPrice.isNaN) {
                                  widget._totalPriceController.text = widget
                                      ._totalPriceCurrencyFormater
                                      .format((itemPrice *
                                              widget.itemData.quantityInTheCart)
                                          .toStringAsFixed(2));
                                } else {
                                  var totalPrice = widget
                                      ._totalPriceCurrencyFormater
                                      .getUnformattedValue();

                                  if (!totalPrice.isNaN &&
                                      widget.itemData.quantityInTheCart != 0) {
                                    widget._itemPriceController.text = widget
                                        ._itemPriceCurrencyFormater
                                        .format((totalPrice /
                                                widget
                                                    .itemData.quantityInTheCart)
                                            .toStringAsFixed(2));
                                  }
                                }
                              } on Exception catch (_) {
                                widget._totalPriceController.text = widget
                                    ._totalPriceCurrencyFormater
                                    .format(0.toStringAsFixed(2));
                                debugPrint(
                                    "It was not possible to set the total price value");
                              }
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
                              if (widget.itemData.quantityInTheCart > 0) {
                                try {
                                  var itemPrice = widget
                                      ._itemPriceCurrencyFormater
                                      .getUnformattedValue();

                                  widget._totalPriceController.text = widget
                                      ._totalPriceCurrencyFormater
                                      .format((itemPrice *
                                              widget.itemData.quantityInTheCart)
                                          .toStringAsFixed(2));
                                } on Exception catch (_) {
                                  widget._totalPriceController.text = widget
                                      ._totalPriceCurrencyFormater
                                      .format(0.toStringAsFixed(2));
                                }
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
                          AppLocalizations.of(context)!.itemPrice,
                          const TextInputType.numberWithOptions(
                              decimal: true, signed: false),
                          widget._itemPriceController,
                          inputFormatter: [widget._itemPriceCurrencyFormater],
                          padding: EdgeInsets.zero,
                          hintText: NumberFormat().format(1.50),
                          fontSize: 14,
                          onChanged: (text) {
                            if (widget.itemData.quantityInTheCart > 0) {
                              try {
                                var itemPrice = widget
                                    ._itemPriceCurrencyFormater
                                    .getUnformattedValue();

                                widget._totalPriceController.text = widget
                                    ._totalPriceCurrencyFormater
                                    .format((itemPrice *
                                            widget.itemData.quantityInTheCart)
                                        .toStringAsFixed(2));
                              } on Exception catch (e) {
                                widget._totalPriceController.text = widget
                                    ._totalPriceCurrencyFormater
                                    .format(0.toStringAsFixed(2));
                              }
                            }
                          },
                        ))
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
                            child: DefaultInput(
                          AppLocalizations.of(context)!.totalPrice,
                          TextInputType.text,
                          widget._totalPriceController,
                          inputFormatter: [widget._totalPriceCurrencyFormater],
                          padding: EdgeInsets.zero,
                          fontSize: 14,
                          onChanged: (text) {
                            if (widget.itemData.quantityInTheCart > 0) {
                              try {
                                var totalPrice = widget
                                    ._totalPriceCurrencyFormater
                                    .getUnformattedValue();

                                if (totalPrice != double.infinity &&
                                    !totalPrice.isNaN &&
                                    widget.itemData.quantityInTheCart != 0) {
                                  widget._itemPriceController.text = widget
                                      ._itemPriceCurrencyFormater
                                      .format((totalPrice /
                                              widget.itemData.quantityInTheCart)
                                          .toStringAsFixed(2));
                                }
                              } on Exception catch (_) {}
                            }
                          },
                          hintText: NumberFormat().format(3.00),
                        ))
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
                      var itemPrice = widget._itemPriceCurrencyFormater
                          .getUnformattedValue();
                      if (!itemPrice.isNaN && !itemPrice.isInfinite) {
                        widget.itemData.itemPrice = itemPrice.toDouble();
                      }

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
  int expectedQuantity;
  int quantityInTheCart;
  String itemName;

  ItemChangedData(this.itemName, this.expectedQuantity, this.quantityInTheCart,
      this.itemPrice);
}
