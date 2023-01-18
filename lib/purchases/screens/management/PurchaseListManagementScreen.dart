import 'package:finance_controlinator_mobile/purchases/webclients/PurchaseListWebClient.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/PurchaseCategory.dart';
import '../../domain/PurchaseList.dart';
import '../../webclients/CategoryWebClient.dart';
import '../shopping/initiation/ShoppingInitiation.dart';
import 'PurchaseCategoryAdderWidget.dart';
import 'PurchaseListManagement.dart';

class PurchaseListManagementScreen extends StatelessWidget {
  static String name = "PurchaseListManagementScreen";

  PurchaseList _purchaseList;
  final purchaseListManagementStateKey =
      GlobalKey<PurchaseListManagementState>();

  PurchaseListManagementScreen(PurchaseList purchaseList, {Key? key})
      : _purchaseList = purchaseList,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_purchaseList.name),
          actions: [
            addCategoryButton(_purchaseList,
                purchaseListManagementStateKey.currentState?.loadLists)
          ],
        ),
        backgroundColor: Colors.grey.shade200,
        body: purchaseListManagementContainer(_purchaseList),
        floatingActionButton: initShoppingButton(context, _purchaseList));
  }

  Widget addCategoryButton(PurchaseList list, Function? loadLists) {
    return PurchaseCategoryAdderWidget(onActionDispatched: (name, color) async {
      var result = await CategoryWebClient().addCategory(
          PurchaseCategory(Uuid().v4(), name, list.id!, color.value));
      if (result.success()) {
        loadLists!();
      }

      return result.success();
    });
  }

  Widget purchaseListManagementContainer(PurchaseList list) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child:
              PurchaseListManagement(list, key: purchaseListManagementStateKey),
        ),
      ],
    );
  }

  FloatingActionButton initShoppingButton(
      BuildContext context, PurchaseList list) {
    return FloatingActionButton(
      backgroundColor: Colors.blueAccent,
      child: const Icon(Icons.arrow_forward),
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
          settings: RouteSettings(name: ShoppingInitiationScreen.name),
          builder: (c) => ShoppingInitiationScreen(list))),
    );
  }

  Scaffold loadingScaffold() {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Loading"),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ));
  }
}
