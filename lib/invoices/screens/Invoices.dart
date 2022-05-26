import 'dart:async';

import 'package:finance_controlinator_mobile/invoices/domain/sync/InvoiceSync.dart';
import 'package:finance_controlinator_mobile/invoices/services/InvoiceSyncService.dart';
import 'package:finance_controlinator_mobile/invoices/services/SyncStorageService.dart';

import 'package:flutter/material.dart';
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

  InvoiceMonthDatasScreen(this.invoiceMonthData, {Key? key}) : super(key: key);

  //todo: do it for each of the list
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [InvoiceDataScreen(invoiceMonthData.first)],
    );
  }
}

class InvoiceDataScreen extends StatelessWidget {
  InvoiceMonthData invoiceMonthData;

  InvoiceDataScreen(this.invoiceMonthData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: InvoiceOverviewScreen(invoiceMonthData.overview),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(invoiceMonthData.invoice.id),
        )
      ],
    );
  }
}
