import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:finance_controlinator_mobile/purchases/domain/shopping/cart/events/ReorderItemEvent.dart';
import 'package:finance_controlinator_mobile/purchases/screens/shopping/inprogress/ShoppingInProgressItemWidget.dart';
import 'package:flutter/material.dart';

import '../../../../authentications/services/AuthorizationService.dart';
import '../../../domain/shopping/Shopping.dart';
import '../../../domain/shopping/ShoppingCategory.dart';
import '../../../domain/shopping/ShoppingItem.dart';
import '../../../domain/shopping/ShoppingList.dart';
import '../../../domain/shopping/cart/events/ReorderCategoryEvent.dart';
import '../../../webclients/shopping/CartEventWebClient.dart';
import '../../../webclients/shopping/ShoppingListWebClient.dart';

class ShoppingInProgressScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final Shopping _shopping;

  ShoppingInProgressScreen(this._shopping, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_shopping.title),
        ),
        backgroundColor: Colors.grey.shade200,
        body: ShoppingListView(_shopping.id),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.arrow_forward),
          onPressed: () async {},
        ));
  }
}

class ShoppingListView extends StatefulWidget {
  String shoppingListId;

  ShoppingListView(this.shoppingListId);

  @override
  State<ShoppingListView> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingListView> {
  ShoppingList? shoppingList;

  bool loadingData = true;

  @override
  void initState() {
    super.initState();
    loadShoppingList();
  }

  Future loadShoppingList() async {
    setState(() {
      loadingData = true;
    });

    var response = await ShoppingListWebClient().getById(widget.shoppingListId);

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
      shoppingList = response.data!;
      loadingData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: loadShoppingList,
        child: loadingData
            ? const Center(child: CircularProgressIndicator())
            : DragAndDropLists(
                listPadding: const EdgeInsets.all(16),
                listInnerDecoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(10)),
                children: shoppingList != null
                    ? buildLists(shoppingList!.categories)
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

  void onItemReorder(int oldItemIndex, int oldListIndex, int newItemIndex,
      int newListIndex) async {
    var newCategory = shoppingList!.categories[newListIndex];

    final item = shoppingList!.categories[oldListIndex].items![oldItemIndex];

    setState(() {
      final oldListItems = shoppingList!.categories[oldListIndex].items;
      final newListItems = shoppingList!.categories[newListIndex].items;

      final movedItem = oldListItems!.removeAt(oldItemIndex);
      newListItems!.insert(newItemIndex, movedItem);
    });

    var result = await CartEventWebClient().sendReorderItemEvent(
        ReorderItemEvent(
            shoppingList!.shoppingId, item.id!, newCategory.id!, newItemIndex));

    if (!result.success()) {
      await loadShoppingList();
    }
  }

  void onListReorder(int oldListIndex, int newListIndex) async {
    var category = shoppingList!.categories[oldListIndex];

    setState(() {
      final movedList = shoppingList!.categories.removeAt(oldListIndex);
      shoppingList!.categories.insert(newListIndex, movedList);
    });

    var result = await CartEventWebClient().sendReorderCategoryEvent(
        ReorderCategoryEvent(
            shoppingList!.shoppingId, category.id!, newListIndex));

    if (!result.success()) {
      await loadShoppingList();
    }
  }

  List<DragAndDropList> buildLists(List<ShoppingCategory> categories) =>
      categories.map((category) => buildCategoryList(category)).toList();

  DragAndDropItem buildShoppingItem(ShoppingItem item) => DragAndDropItem(
      child: ShoppingInProgressItemWidget(shoppingList!.shoppingId, item, loadShoppingList));

  DragAndDropList buildCategoryList(ShoppingCategory category) =>
      DragAndDropList(
          header: GestureDetector(
              child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(8),
                  child: Text(category.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(category.color))))),
          children: category.items!.map(buildShoppingItem).toList());

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
