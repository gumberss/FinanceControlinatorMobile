import 'package:finance_controlinator_mobile/purchases/domain/shopping/Shopping.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:finance_controlinator_mobile/purchases/domain/shopping/ShoppingList.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ShoppingSummaryScreen extends StatelessWidget {
  final Shopping _shopping;

  ShoppingSummaryScreen(Shopping shopping, {Key? key})
      : _shopping = shopping,
        super(key: key);

  Widget buildTextWidget(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title + ": ",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text(value)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.summary,
          ),
        ),
        backgroundColor: Colors.grey.shade200,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                children: [
                  buildTextWidget(context, AppLocalizations.of(context)!.place,
                      _shopping.place),

                  buildTextWidget(context, AppLocalizations.of(context)!.shoppingType,
                      _shopping.type),

                  buildTextWidget(context, AppLocalizations.of(context)!.title,
                      _shopping.title),

                  buildTextWidget(context, AppLocalizations.of(context)!.totalCost,
                      NumberFormat.currency().format(100000.21)),
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.arrow_forward),
            onPressed: () {}));
  }
}
