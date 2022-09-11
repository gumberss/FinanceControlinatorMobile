import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';
import '../../../authentications/services/AuthorizationService.dart';

import '../../domain/PurchaseCategory.dart';
import '../../domain/PurchaseItem.dart';
import '../../domain/PurchaseList.dart';
import '../../domain/PurchaseListManagementData.dart';
import '../../webclients/PurchaseListWebClient.dart';

class PurchaseListManagement extends StatefulWidget {
  PurchaseList _purchaseList;

  PurchaseListManagement(PurchaseList purchaseList, {Key? key})
      : _purchaseList = purchaseList, super(key: key);

  @override
  State<PurchaseListManagement> createState() =>
      PurchaseListManagementState();
}

class PurchaseListManagementState extends State<PurchaseListManagement> {
  PurchaseListManagementData? purchaseListManagementData;

  late List<DragAndDropList> lists;
  bool loadingData = true;

  @override
  void initState() {
    super.initState();
    loadLists();
  }

  Future loadLists() async {
    setState(() {
      loadingData = true;
    });

    var response =
        await PurchaseListWebClient().getItemsAndCategories(widget._purchaseList.id!);

    if (response.unauthorized()) {
      AuthorizationService.redirectToSignIn(context);
      return;
    }

    if (response.serverError()) {
      setState(() {
        loadingData = false;
      });
      //todo: toast error
      return;
    }

    setState(() {
      purchaseListManagementData = response.data!;
      loadingData = false;
    });
  }

  Function(String itemId, int oldPosition, int newPosition) onReorderItem() =>
      (String itemId, int oldPosition, int newPosition) => {};

  DragAndDropItem newItem() => DragAndDropItem(
      canDrag: false,
      child: const ListTile(
        title: Text(
          "+ Item",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: loadLists,
        child: loadingData
            ? const Center(child: CircularProgressIndicator())
            : DragAndDropLists(
                listPadding: const EdgeInsets.all(16),
                listInnerDecoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(10)),
                children: purchaseListManagementData != null
                    ? buildLists(purchaseListManagementData!.categories,
                        <PurchaseItem>[]
                        //purchaseListManagementData!.items
                )
                    : <DragAndDropList>[],
                itemDivider: Divider(
                    thickness: 2, height: 2, color: Colors.grey.shade200),
                itemDecorationWhileDragging: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 4)
                    ]),
                onItemReorder: onItemReorder,
                onListReorder: onListReorder,
                itemDragHandle: buildDragHandle(),
                listDragHandle: buildDragHandle(isList: true),
              ));
  }

  List<DragAndDropList> buildLists(
          List<PurchaseCategory> categories, List<PurchaseItem> items) =>
      categories
          .map((category) => buildCategoryList(
              category,
              items
                  .where((element) => element.categoryId == category.id)
                  .map(buildPurchaseItem)))
          .toList();

  DragAndDropList buildCategoryList(
          PurchaseCategory category, Iterable<DragAndDropItem> categoryItems) =>
      DragAndDropList(
          header: Container(
              padding: const EdgeInsets.all(8),
              child: Text(category.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(category.color)))),
          children: categoryItems.toList()..add(newItem()));

  DragAndDropItem buildPurchaseItem(PurchaseItem item) => DragAndDropItem(
          child: ListTile(
        //leading: Image.network(i.urlImage,width: 40, height: 40, fit: BoxFit.cover),
        title: Text(item.name),
      ));

  void onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      final oldListItems = lists[oldListIndex].children;
      final newListItems = lists[newListIndex].children;

      final movedItem = oldListItems.removeAt(oldItemIndex);
      newListItems.insert(newItemIndex, movedItem);
    });
  }

  void onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      final movedList = lists.removeAt(oldListIndex);
      lists.insert(newListIndex, movedList);
    });
  }

  DragHandle buildDragHandle({bool isList = false}) {
    final verticalAlignment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;

    final color = isList ? Colors.blueGrey : Colors.black26;

    return DragHandle(
      verticalAlignment: verticalAlignment,
      child: Container(
        padding: const EdgeInsets.only(right: 10),
        child: Icon(Icons.menu, color: color),
      ),
    );
  }
}
