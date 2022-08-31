import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../domain/PurchaseList.dart';

class PurchaseListManagement extends StatelessWidget {
  PurchaseList _purchaseList;

  PurchaseListManagement(PurchaseList purchaseList)
      : _purchaseList = purchaseList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
              AppLocalizations.of(context)!.purchaseListScreenTitle), //from dto
        ),
        body: Text(_purchaseList.name),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add),
          onPressed: () => {},
        ));
  }
}
