import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:finance_controlinator_mobile/purchases/domain/PurchaseItem.dart';
import 'package:finance_controlinator_mobile/purchases/webclients/PurchaseListWebClient.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';
import 'dart:math' as math;

import '../../../components/DefaultDialog.dart';
import '../../../components/DefaultInput.dart';
import '../../../components/ExpandableCategoryList.dart';
import '../../domain/PurchaseList.dart';

class PurchaseListManagementScreen extends StatelessWidget {
  PurchaseList _purchaseList;

  PurchaseListManagementScreen(PurchaseList purchaseList)
      : _purchaseList = purchaseList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_purchaseList.name),
          actions: [
            PurchaseCateggoryAdderWidget(
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

class PurchaseCateggoryAdderWidget extends StatefulWidget {
  Function(String title, Color color) onActionDispatched;

  PurchaseCateggoryAdderWidget({Key? key, required this.onActionDispatched})
      : super(key: key);

  @override
  State<PurchaseCateggoryAdderWidget> createState() =>
      _PurchaseCateggoryAdderWidgetState();
}

class _PurchaseCateggoryAdderWidgetState
    extends State<PurchaseCateggoryAdderWidget> {
  late Color pickerColor;

  _PurchaseCateggoryAdderWidgetState() {
    pickerColor = randomColor();
  }

  Widget addCategoryButton() => SizedBox(
        height: 24,
        width: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: const EdgeInsets.only(bottom: 8, right: 16),
                child: const Icon(
                  Icons.category_outlined,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.only(top: 12, left: 12),
                child: const Icon(
                  Icons.add,
                ),
              ),
            ),
          ],
        ),
      );

  Color randomColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(1.0);
  }

  TextEditingController newPurchaseCategoryNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          DefaultDialog().showDialog(
              context,
              addCategoryWidgets(
                  context,
                  AppLocalizations.of(context)!.purchaseCategoryName,
                  newPurchaseCategoryNameController,
                  widget.onActionDispatched),
              height: 490);
        },
        icon: addCategoryButton());
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  List<Widget> addCategoryWidgets(
      BuildContext context,
      String label,
      TextEditingController controller,
      Function(String title, Color color) action) {
    return [
      HueRingPicker(
        pickerColor: pickerColor,
        displayThumbColor: true,
        enableAlpha: false,
        onColorChanged: changeColor,
      ),
      DefaultInput(label, TextInputType.text, controller),
      Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          child: SizedBox(
              width: double.maxFinite,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      primary: Colors.green[900],
                      backgroundColor: Colors.green[100]),
                  onPressed: () async {
                    if (controller.text.isEmpty) {
                      //todo: toast error
                      return;
                    }

                    try {
                      action(controller.text, pickerColor);
                      //todo: toast success
                      controller.clear();
                      Navigator.pop(context);
                    } on Exception catch (e) {
                      debugPrint(e.toString());
                      //todo: toast error
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.create))))
    ];
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
      ]),
      DraggableList(header: "Draggable list 2", items: [
        DraggableListItem(title: "Item 3", urlImage: url),
        DraggableListItem(title: "Item 4", urlImage: url)
      ]),
      DraggableList(header: "Draggable list 2", items: [
        DraggableListItem(title: "Item 3", urlImage: url),
        DraggableListItem(title: "Item 4", urlImage: url)
      ]),
      DraggableList(header: "Draggable list 2", items: [
        DraggableListItem(title: "Item 3", urlImage: url),
        DraggableListItem(title: "Item 4", urlImage: url)
      ])
    ];

    lists = list.map(buildList).toList();
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
    return DragAndDropLists(
      listPadding: const EdgeInsets.all(16),
      listInnerDecoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          borderRadius: BorderRadius.circular(10)),
      children: lists,
      itemDivider:
          Divider(thickness: 2, height: 2, color: Colors.grey.shade200),
      itemDecorationWhileDragging: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      onItemReorder: onItemReorder,
      onListReorder: onListReorder,
      itemDragHandle: buildDragHandle(),
      listDragHandle: buildDragHandle(isList: true),
    );
  }

  DragAndDropList buildList(DraggableList e) => DragAndDropList(
      header: Container(
          padding: const EdgeInsets.all(8),
          child: Text(e.header,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.blueGrey))),
      children: e.items
          .map((i) => DragAndDropItem(
                  child: ListTile(
                //leading: Image.network(i.urlImage,width: 40, height: 40, fit: BoxFit.cover),
                title: Text(i.title),
              )))
          .toList()
        ..add(newItem()));

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
        padding: const EdgeInsets.only(right: 10),
        child: Icon(Icons.menu, color: color),
      ),
    );
  }
}
