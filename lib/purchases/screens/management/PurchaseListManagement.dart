import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../components/ExpandableCategoryList.dart';
import '../../../components/ExpandableList.dart';
import '../../domain/PurchaseList.dart';

class PurchaseListManagementScreen extends StatelessWidget {
  PurchaseList _purchaseList;

  PurchaseListManagementScreen(PurchaseList purchaseList)
      : _purchaseList = purchaseList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_purchaseList.name)),
        body: PurchaseListManagement(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add),
          onPressed: () => {},
        ));
  }
}

class PurchaseListManagement extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var a = [1, 2, 3, 1, 2, 4];
    var c = ["1", "2", "3", "4", "5"];

    return ExpandableCategoryList<String, int>(
        items: a,
        categories: c,
        buildItem: (i) => ListTile(title: Text(i.toString())),
        categoryGroupItemsProperty: (x) => x,
        categoryTitle: (c)=> c,
        buildDefaultTile: (c) => const ListTile(title: Text("Create a nwe one")),
        groupProperty: (i) => i.toString());
  }
}
