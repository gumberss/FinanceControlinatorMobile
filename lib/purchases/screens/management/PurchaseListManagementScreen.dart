import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/PurchaseCategory.dart';
import '../../domain/PurchaseList.dart';
import '../../webclients/CategoryWebClient.dart';
import '../shopping/sessions/ShoppingSessionsScreen.dart';
import 'PurchaseCategoryAdderWidget.dart';
import 'PurchaseListManagement.dart';

class PurchaseListManagementScreen extends StatelessWidget {
  static String name = "PurchaseListManagementScreen";

  final PurchaseList _purchaseList;
  final purchaseListManagementStateKey =
      GlobalKey<PurchaseListManagementState>();

  PurchaseListManagementScreen(PurchaseList purchaseList, {super.key})
      : _purchaseList = purchaseList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_purchaseList.name),
          actions: [
            addCategoryButton(_purchaseList,
                () => purchaseListManagementStateKey.currentState?.loadLists()),
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Lists',
              onPressed: () {
                purchaseListManagementStateKey.currentState?.loadLists();
              },
            ),
          ],
        ),
        backgroundColor: Colors.grey.shade200,
        body: purchaseListManagementContainer(_purchaseList),
        floatingActionButton: initShoppingButton(context, _purchaseList));
  }

  Widget addCategoryButton(PurchaseList list, Function? loadLists) {
    return PurchaseCategoryAdderWidget(onActionDispatched: (name, color) async {
      var result = await CategoryWebClient().addCategory(
          PurchaseCategory(const Uuid().v4(), name, list.id!, color.value));
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
          settings: const RouteSettings(name: ShoppingSessionsScreen.name),
          builder: (c) => ShoppingSessionsScreen(list))),
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
