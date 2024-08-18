import 'dart:async';
import 'package:finance_controlinator_mobile/invoices/domain/sync/InvoiceSync.dart';
import 'package:flutter/material.dart';
import '../../expenses/components/InfiniteList.dart';

class InvoiceItemsComponent extends StatelessWidget {
  List<InvoiceItem> items;

  InvoiceItemsComponent(this.items, {super.key});

  Future<List<InvoiceItem>> requestItems(int page, int itemsCount) async {
    return items.skip(page * itemsCount).take(itemsCount).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InifiniteList<InvoiceItem>(
        onRequest: (page, count) => requestItems(page - 1, count),
        itensPerPage: 10,
        itemBuilder: (context, item, index) => Container(
            height: 100,
            decoration: BoxDecoration(
                color: InvoiceItem.colors[item.type],
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.6),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: const Offset(2, 2), // changes position of shadow
                  )
                ]),
            margin: const EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Text(item.installmentNumber)
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(item.installmentCost),
                    Text(item.purchaseDay),
                  ],
                )
              ],
            )),
      ),
    );
  }
}
