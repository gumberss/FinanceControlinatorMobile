import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:finance_controlinator_mobile/purchases/domain/shopping/cart/events/ReorderItemEvent.dart';
import 'package:finance_controlinator_mobile/purchases/screens/shopping/inprogress/ShoppingInProgressItemWidget.dart';
import 'package:finance_controlinator_mobile/purchases/screens/shopping/summary/ShoppingSummaryScreen.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'dart:convert';

import '../../../../authentications/services/AuthorizationService.dart';
import '../../../domain/shopping/Shopping.dart';
import '../../../domain/shopping/ShoppingCategory.dart';
import '../../../domain/shopping/ShoppingItem.dart';
import '../../../domain/shopping/ShoppingList.dart';
import '../../../domain/shopping/cart/events/ReorderCategoryEvent.dart';
import '../../../webclients/shopping/CartEventWebClient.dart';
import '../../../webclients/shopping/ShoppingListWebClient.dart';
import '../../../../components/screens/TakePictureScreen.dart';

class ShoppingInProgressScreen extends StatelessWidget {
  static String name = "ShoppingInProgressScreen";
  final Shopping _shopping;
  final _shoppingListKey = GlobalKey<_ShoppingListState>();

  ShoppingInProgressScreen(this._shopping, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_shopping.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Refresh Lists',
              onPressed: () {
                _shoppingListKey.currentState?.loadShoppingList();
              },
            ),
            IconButton(
              icon: const Icon(Icons.checklist),
              tooltip: 'Check using IA',
              onPressed: () async {
                final takePictureScreen = await createTakePictureScreen();
                   var imagePath =  await Navigator.of(context).push(MaterialPageRoute(
                    builder: (c) =>  takePictureScreen));
                final File imageFile = File(imagePath);
                final bytes = await imageFile.readAsBytes();
                String base64Image = base64Encode(bytes);


                await _shoppingListKey!.currentState!.markItemsWithIA(base64Image);


                // Convert the bytes to a Base64 string
                //_shoppingListKey.currentState?.markItemsWithIA();
              },
            )
          ],
        ),
        backgroundColor: Colors.grey.shade200,
        body: ShoppingListView(_shopping.id, _shoppingListKey),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.arrow_forward),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (c) => ShoppingSummaryScreen(
                  _shopping, _shoppingListKey.currentState?.shoppingList))),
        ));
  }
}

class ShoppingListView extends StatefulWidget {
  String shoppingListId;

  ShoppingListView(this.shoppingListId, Key? key) : super(key: key);

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

  Future markItemsWithIA(String image64) async {
    setState(() {
      loadingData = true;
    });

    var response = await ShoppingListWebClient().markItemsWithIA(widget.shoppingListId, image64);

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

  Future<void> onItemReorder(int oldItemIndex, int oldListIndex,
      int newItemIndex, int newListIndex) async {
    var newCategory = shoppingList!.categories[newListIndex];

    final item = shoppingList!.categories[oldListIndex].items![oldItemIndex];

    setState(() {
      final oldListItems = shoppingList!.categories[oldListIndex].items;
      final newListItems = shoppingList!.categories[newListIndex].items;

      final movedItem = oldListItems!.removeAt(oldItemIndex);
      newListItems!.insert(newItemIndex, movedItem);
    });

    var result = await CartEventWebClient().sendReorderItemEvent(
        ReorderItemEvent(const Uuid().v4(), shoppingList!.shoppingId, item.id!,
            newCategory.id!, newItemIndex));

    if (!result.success()) {
      await loadShoppingList();
    }
  }

  Future<void> onListReorder(int oldListIndex, int newListIndex) async {
    var category = shoppingList!.categories[oldListIndex];

    setState(() {
      final movedList = shoppingList!.categories.removeAt(oldListIndex);
      shoppingList!.categories.insert(newListIndex, movedList);
    });

    var result = await CartEventWebClient().sendReorderCategoryEvent(
        ReorderCategoryEvent(
            const Uuid().v4(), shoppingList!.shoppingId, category.id!, newListIndex));

    if (!result.success()) {
      await loadShoppingList();
    }
  }

  List<DragAndDropList> buildLists(List<ShoppingCategory> categories) =>
      categories.map((category) => buildCategoryList(category)).toList();

  DragAndDropItem buildShoppingItem(ShoppingItem item) => DragAndDropItem(
      child: ShoppingInProgressItemWidget(
          shoppingList!.shoppingId, item, loadShoppingList));

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
