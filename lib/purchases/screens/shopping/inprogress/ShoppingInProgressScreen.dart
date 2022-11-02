import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:finance_controlinator_mobile/purchases/domain/shopping/cart/events/ReorderItemEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../authentications/services/AuthorizationService.dart';
import '../../../../components/DefaultDialog.dart';
import '../../../../components/DefaultInput.dart';
import '../../../domain/shopping/Shopping.dart';
import '../../../domain/shopping/ShoppingCategory.dart';
import '../../../domain/shopping/ShoppingItem.dart';
import '../../../domain/shopping/ShoppingList.dart';
import '../../../domain/shopping/cart/events/EventTypes.dart';
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

  void showDialog() {
    DefaultDialog().showDialog(
        context,
        addCategoryWidgets(
          context,
          AppLocalizations.of(context)!.purchaseCategoryName,
        ),
        height: 260,
        mainAlignment: MainAxisAlignment.spaceBetween);
  }

  TextEditingController _itemValueController = TextEditingController();
  TextEditingController _totalValueController = TextEditingController();

  List<Widget> addCategoryWidgets(
    BuildContext context,
    String label,
  ) {
    return [
      Padding(
        padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Banana", style: TextStyle(fontSize: 24)),
                      Text("Quantity in the cart: 10",
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[700])),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_upward)),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          width: 2,
                          height: 20,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_downward)),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      Expanded(
                          child: DefaultInput(
                        "Item Value",
                        TextInputType.text,
                        _itemValueController,
                        padding: EdgeInsets.zero,
                        fontSize: 14,
                      )),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.remove)),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          width: 2,
                          height: 20,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                    ],
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                          child: DefaultInput(
                        "Total Value",
                        TextInputType.text,
                        _totalValueController,
                        padding: EdgeInsets.zero,
                        fontSize: 14,
                      )),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.remove)),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Container(
                          width: 2,
                          height: 20,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      IconButton(onPressed: () {}, icon: const Icon(Icons.add)),
                    ],
                  ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  child: Text(AppLocalizations.of(context)!.create),
                  onPressed: () {},
                )
              ],
            )
          ],
        ),
      )
    ];
  }

  List<DragAndDropList> buildLists(List<ShoppingCategory> categories) =>
      categories.map((category) => buildCategoryList(category)).toList();

  DragAndDropItem buildShoppingItem(ShoppingItem item) => DragAndDropItem(
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
                    showDialog();
                  },
                  icon: const Icon(Icons.check)),
            ],
          ),
        ),
      ));

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
