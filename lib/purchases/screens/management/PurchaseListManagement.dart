import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../../components/ExpandableCategoryList.dart';
import '../../domain/PurchaseList.dart';

class PurchaseListManagementScreen extends StatelessWidget {
  PurchaseList _purchaseList;

  PurchaseListManagementScreen(PurchaseList purchaseList)
      : _purchaseList = purchaseList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_purchaseList.name)),
        backgroundColor: Colors.grey.shade200,
        body: PurchaseListManagement(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add),
          onPressed: () => {},
        ));
  }
}

class PurchaseListManagement extends StatefulWidget {
  @override
  State<PurchaseListManagement> createState() => _PurchaseListManagementState();
}

class _PurchaseListManagementState extends State<PurchaseListManagement> {
  late List<DragAndDropList> lists;

  @override
  void initState() {
    super.initState();
    var url =
        "https://blog.deliverymuch.com.br/wp-content/uploads/2020/06/O-que-%C3%A9-fast-food-Conhe%C3%A7a-o-milion%C3%A1rio-mercado-de-comidas-r%C3%A1pidas-750x410.jpg";
    var list = [
      DraggableList(header: "Draggable list 1", items: [
        DraggableListItem(title: "Item 1", urlImage: url),
        DraggableListItem(title: "Item 2", urlImage: url)
      ]),
      DraggableList(header: "Draggable list 2", items: [
        DraggableListItem(title: "Item 3", urlImage: url),
        DraggableListItem(title: "Item 4", urlImage: url)
      ])
    ];

    lists = list.map(buildList).toList();
  }

  @override
  Widget build(BuildContext context) {
    var a = [1, 2, 3, 1, 2, 4];
    var c = ["1", "2", "3", "4", "5"];

    return DragAndDropLists(
      listPadding: EdgeInsets.all(16),
      listInnerDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(10)),
      children: lists,
      itemDivider:
          Divider(thickness: 2, height: 2, color: Colors.grey.shade200),
      itemDecorationWhileDragging: BoxDecoration(color: Colors.white,
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      onItemReorder: onItemReorder,
      onListReorder: onListReorder,
      itemDragHandle: buildDragHandle(),
      listDragHandle: buildDragHandle(isList: true),
    );

    /*
   *  return ExpandableCategoryList<String, int>(
        items: a,
        categories: c,
        buildItem: (i) => LongPressDraggable(
              data: i,
              child: ListTile(title: Text(i.toString())),
              feedback: Material(
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width),
                      child: ListTile(title: Text(i.toString())))),
              childWhenDragging: Container(),
            ),
        categoryGroupItemsProperty: (x) => x,
        buildCategoryTile: (c, items) => DragTarget<int>(ExpansionTile(
            initiallyExpanded: true, title: Text(c), children: items)),
        buildDefaultTile: (c) => LongPressDraggable(
              child: ListTile(title: Text("Create a new one")),
              data: c,
              feedback: Text("Create a new one"),
              childWhenDragging: Container(),
            ),
        itemGroupProperty: (i) => i.toString());*/
  }

  DragAndDropList buildList(DraggableList e) => DragAndDropList(
      header: Container(
          padding: EdgeInsets.all(8),
          child: Text(e.header,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
      children: e.items
          .map((i) => DragAndDropItem(
                  child: ListTile(
                leading: Image.network(i.urlImage,
                    width: 40, height: 40, fit: BoxFit.cover),
                title: Text(i.title),
              )))
          .toList());

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
    final verticalAligment = isList
        ? DragHandleVerticalAlignment.top
        : DragHandleVerticalAlignment.center;

    final color = isList ? Colors.blueGrey : Colors.black26;

    return DragHandle(
      verticalAlignment: verticalAligment,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.menu, color: color),
      ),
    );
  }
}
