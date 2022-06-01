import 'dart:async';
import 'package:collection/collection.dart';
import 'package:finance_controlinator_mobile/invoices/domain/sync/InvoiceSync.dart';
import 'package:finance_controlinator_mobile/invoices/services/InvoiceSyncService.dart';
import 'package:finance_controlinator_mobile/invoices/services/SyncStorageService.dart';

import 'package:flutter/material.dart';
import '../../expenses/components/InfiniteList.dart';
import '../domain/sync/InvoiceSync.dart';
import '../webclients/InvoiceSyncWebClient.dart';
import 'InvoiceOverview.dart';

class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: syncInvoices(),
        builder: (context, AsyncSnapshot<InvoiceSync?> snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Loading"), //from dto
                ),
                body: const Center(
                  child: CircularProgressIndicator(),
                ));
          }

          var response = snapshot.data!;
          //if (response.unauthorized()) {
          //AuthorizationService.redirectToSignIn(context);
          // return Text("Unauthorized :(");
          //       } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(response.syncName), //from dto
            ),
            body: InvoiceMonthDatasScreen(response.monthDataSyncs),
          );
        }
        // },
        );
  }

  Future<InvoiceSync?> syncInvoices() async {
    var syncStorage = SyncStorageService();

    var lastSync = await syncStorage.stored();
    var response =
        await InvoiceSyncWebClient().getSyncData(lastSync?.syncDate ?? 0);

    //todo: if timeout happen, show a toast
    if (response.unauthorized()) {
      return null;
    }
    if (response.data == null) {
      return lastSync;
    }
    var updated = InvoiceSyncService().updateSync(lastSync, response.data!);
    await syncStorage.store(updated);

    return updated;
  }
}

class InvoiceMonthDatasScreen extends StatelessWidget {
  List<InvoiceMonthData> invoiceMonthData;
  late PageController pageController;

  InvoiceMonthDatasScreen(this.invoiceMonthData, {Key? key}) : super(key: key);

  //todo: do it for each item in the list
  @override
  Widget build(BuildContext context) {
    //todo: always open the screen with the opened invoice selected
    var initialMonthData =
        invoiceMonthData.where((element) => element.overview.status == 0);

    if (initialMonthData.isEmpty) {
      initialMonthData =
          invoiceMonthData.where((element) => element.overview.status == 2);
    }

    if (initialMonthData.isEmpty) {
      initialMonthData =
          invoiceMonthData.where((element) => element.overview.status == 4);
    }

    if (initialMonthData.isEmpty) {
      initialMonthData =
          invoiceMonthData.where((element) => element.overview.status == 3);
    }

    pageController = PageController(
      initialPage: invoiceMonthData.firstOrNull?.overview.status ??
          invoiceMonthData.length - 1,
    );
    PageView pageView = PageView(
      controller: pageController,
      children: invoiceMonthData
          .map((e) => Column(
                children: [Expanded(child: InvoiceDataScreen(e))],
              ))
          .toList(),
    );

    return pageView;
  }
}

class InvoiceDataScreen extends StatelessWidget {
  InvoiceMonthData invoiceMonthData;

  InvoiceDataScreen(this.invoiceMonthData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 40,
          child: InvoiceOverviewScreen(invoiceMonthData.overview),
        ),
        Expanded(
            flex: 60,
            child: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: InvoiceItemsComponent(invoiceMonthData.invoice.items!),
            ))
      ],
    );
  }
}

class InvoiceItemsComponent extends StatelessWidget {
  List<InvoiceItem> items;

  InvoiceItemsComponent(this.items, {Key? key}) : super(key: key);

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
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
