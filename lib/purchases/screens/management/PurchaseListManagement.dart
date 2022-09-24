import 'package:finance_controlinator_mobile/purchases/webclients/ItemWebClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:finance_controlinator_mobile/components/DefaultInput.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../authentications/services/AuthorizationService.dart';

import '../../domain/PurchaseCategory.dart';
import '../../domain/PurchaseItem.dart';
import '../../domain/PurchaseList.dart';
import '../../domain/PurchaseListManagementData.dart';
import '../../webclients/CategoryWebClient.dart';
import '../../webclients/PurchaseListWebClient.dart';

class PurchaseListManagement extends StatefulWidget {
  PurchaseList _purchaseList;

  PurchaseListManagement(PurchaseList purchaseList, {Key? key})
      : _purchaseList = purchaseList,
        super(key: key);

  @override
  State<PurchaseListManagement> createState() => PurchaseListManagementState();
}

class PurchaseListManagementState extends State<PurchaseListManagement> {
  PurchaseListManagementData? purchaseListManagementData;

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

    var response = await PurchaseListWebClient()
        .getItemsAndCategories(widget._purchaseList.id!);

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

  TextEditingController newItemNameController = TextEditingController();

  DragAndDropItem newItem(PurchaseCategory category) => DragAndDropItem(
      canDrag: false,
      child: addingItemCategory != null && addingItemCategory == category.id
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: DefaultInput(
                    AppLocalizations.of(context)!.purchaseCategoryItem,
                    TextInputType.text,
                    newItemNameController,
                    autoFocus: true,
                    onSubmitted: () async {
                      setState(() {
                        addingItem = true;
                      });

                      var result = await ItemWebClient().addItem(PurchaseItem(
                        const Uuid().v4(),
                        newItemNameController.text,
                        category.id!,
                      ));
                      if (result.success()) {
                        onAddItem(null);
                        loadLists();
                      } else {
                        setState(() {
                          addingItem = false;
                        });
                      }
                    },
                  ),
                ),
                IconButton(
                    onPressed: () {
                      onAddItem(null);
                    },
                    icon: const Icon(Icons.close))
              ],
            )
          : ListTile(
              onTap: () => onAddItem(category),
              title: const Text(
                "+ Item",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ));

  String? addingItemCategory;
  bool addingItem = false;

  void onAddItem(PurchaseCategory? category) {
    setState(() {
      addingItem = false;
      newItemNameController.clear();
      addingItemCategory = category?.id;
    });
  }

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
                    ? buildLists(purchaseListManagementData!.categories)
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

  List<DragAndDropList> buildLists(List<PurchaseCategory> categories) =>
      categories.map((category) => buildCategoryList(category)).toList();

  DragAndDropList buildCategoryList(PurchaseCategory category) =>
      DragAndDropList(
          header: Container(
              padding: const EdgeInsets.all(8),
              child: Text(category.name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(category.color)))),
          children: category.items!.map(buildPurchaseItem).toList()
            ..add(newItem(category)));

  void delaySendToServer(PurchaseItem item){
    var currentItemAmount = item.quantity;
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (item.quantity == currentItemAmount) {
        ItemWebClient().changeItemQuantity(item.id!, item.quantity);
      }
    });
  }

  DragAndDropItem buildPurchaseItem(PurchaseItem item) => DragAndDropItem(
          child: ListTile(
        //leading: Image.network(i.urlImage,width: 40, height: 40, fit: BoxFit.cover),
        title: Text(item.name),
        subtitle: Text(AppLocalizations.of(context)!.amountToBuy +
            item.quantity.toString()),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 24),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      item.quantity++;
                    });
                    delaySendToServer(item);
                  },
                  icon: const Icon(Icons.arrow_upward)),
              Padding(
                padding: const EdgeInsets.all(4),
                child: Container(
                  width: 2,
                  color: Colors.grey.shade300,
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (item.quantity > 0) {
                      setState(() {
                        item.quantity--;
                      });
                      delaySendToServer(item);
                    }
                  },
                  icon: const Icon(Icons.arrow_downward)),
            ],
          ),
        ),
      ));

  bool itemPlacedAfterNewItemButton(int newListIndex, int newItemIndex) {
    return newItemIndex > 0 &&
        newItemIndex >=
            purchaseListManagementData!.categories[newListIndex].items!.length;
  }

  void onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,
      int newListIndex) async {
    var newCategory = purchaseListManagementData!.categories[newListIndex];

    final item = purchaseListManagementData!
        .categories[oldListIndex].items![oldItemIndex];

    if (itemPlacedAfterNewItemButton(newListIndex, newItemIndex)) {
      newItemIndex--;
    }

    setState(() {
      final oldListItems =
          purchaseListManagementData!.categories[oldListIndex].items;
      final newListItems =
          purchaseListManagementData!.categories[newListIndex].items;

      final movedItem = oldListItems!.removeAt(oldItemIndex);
      newListItems!.insert(newItemIndex, movedItem);
    });

    var result = await ItemWebClient()
        .changeItemOrder(item.id!, newCategory.id!, newItemIndex);

    if (!result.success()) {
      await loadLists();
    }
  }

  void onListReorder(int oldListIndex, int newListIndex) async {
    var category = purchaseListManagementData!.categories[oldListIndex];

    setState(() {
      final movedList =
          purchaseListManagementData!.categories.removeAt(oldListIndex);
      purchaseListManagementData!.categories.insert(newListIndex, movedList);
    });

    var result = await CategoryWebClient()
        .changeCategoryOrder(category.id!, newListIndex);

    if (!result.success()) {
      await loadLists();
    }
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
