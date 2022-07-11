import 'package:finance_controlinator_mobile/purchases/webclients/PurchaseListWebClient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import '../domain/PurchaseList.dart';

class PurchaseListItem extends StatelessWidget {
  final PurchaseList _purchaseList;
  final Function _onChangeHappen;

  const PurchaseListItem(PurchaseList purchaseList, Function onChangeHappen,
      {Key? key})
      : _purchaseList = purchaseList,
        _onChangeHappen = onChangeHappen,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.lightGreen.shade100,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.6),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(2, 2))
            ]),
        margin: const EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
        child: Slidable(
          startActionPane: slideLeftBackground(context),
          endActionPane: slideRightBackground(context),
          key: Key(_purchaseList.name),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        _purchaseList.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
              _purchaseList.inProgress
                  ? const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.blueAccent,
                      ))
                  : const SizedBox.shrink(),
            ],
          ),
        ));
  }

  ActionPane slideLeftBackground(BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            await PurchaseListWebClient().disable(_purchaseList.id!);
            _onChangeHappen();
          },
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          icon: Icons.delete,
        )
      ],
    );
  }

  ActionPane slideRightBackground(BuildContext context) {
    return ActionPane(
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) {},
          backgroundColor: Colors.greenAccent,
          foregroundColor: Colors.white,
          icon: Icons.edit,
        ),
        SlidableAction(
          onPressed: (ctx) {},
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          icon: Icons.link,
        )
      ],
    );
  }
}
