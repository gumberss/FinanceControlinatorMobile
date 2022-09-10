import 'package:finance_controlinator_mobile/purchases/webclients/PurchaseListWebClient.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/PurchaseCategory.dart';
import '../../domain/PurchaseList.dart';
import 'PurchaseCategoryAdderWidget.dart';
import 'PurchaseListManagement.dart';

class PurchaseListManagementScreen extends StatelessWidget {
  final PurchaseList _purchaseList;

  const PurchaseListManagementScreen(PurchaseList purchaseList, {Key? key})
      : _purchaseList = purchaseList, super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_purchaseList.name),
          actions: [
            PurchaseCategoryAdderWidget(
                onActionDispatched: (name, color) => {
                      PurchaseListWebClient().addCategory(
                          _purchaseList.id!,
                          PurchaseCategory(Uuid().v4(), name, _purchaseList.id!,
                              color.value))
                    })
          ],
        ),
        backgroundColor: Colors.grey.shade200,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: PurchaseListManagement(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add),
          onPressed: () => {},
        ));
  }
}


