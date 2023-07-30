import 'package:finance_controlinator_mobile/purchases/domain/PurchaseList.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../initiation/ShoppingInitiation.dart';

class ShoppingSessionsScreen extends StatelessWidget {
  final PurchaseList _purchaseList;
  static const String name = "ShoppingSessionsScreen";

  ShoppingSessionsScreen(this._purchaseList, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.shoppingInProgress)),
        backgroundColor: Colors.grey.shade200,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [],
          ),
        ),
        floatingActionButton: initShoppingButton(context, _purchaseList));
  }

  FloatingActionButton initShoppingButton(
      BuildContext context, PurchaseList list) {
    return FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      child: const Icon(Icons.add),
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: ShoppingInitiationScreen.name),
          builder: (c) => ShoppingInitiationScreen(list))),
    );
  }
}
