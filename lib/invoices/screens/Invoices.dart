import 'dart:async';

import 'package:finance_controlinator_mobile/invoices/domain/sync/InvoiceSync.dart';
import 'package:finance_controlinator_mobile/invoices/services/InvoiceSyncService.dart';
import 'package:finance_controlinator_mobile/invoices/services/SyncStorageService.dart';

import 'package:flutter/material.dart';
import '../../expenses/components/OverviewCard.dart';
import '../../expenses/components/OverviewSpendBar.dart';
import '../domain/sync/InvoiceSync.dart';
import '../webclients/InvoiceSyncWebClient.dart';

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

class InvoiceOverviewScreen extends StatelessWidget {
  InvoiceOverview overview;

  InvoiceOverviewScreen(this.overview, {Key? key}) : super(key: key);

  final List<Color> colors = [
    Colors.redAccent,
    Colors.lightGreen,
    Colors.orangeAccent.shade700,
    Colors.lightBlueAccent.shade700,
    Colors.tealAccent.shade700,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        color: colors[overview.status].withOpacity(0.2),
        alignment: Alignment.topCenter,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OverviewHeader(overview.date, overview.statusText,
                        overview.totalCost)),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OverviewBriefs(overview.briefs)),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: OverviewSpendBar(overview.partitions
                        .map((e) => PartitionData(
                            e.type, e.typeText, e.percent, e.totalValue))
                        .toList())),
              ],
            )));
  }
}

class OverviewHeader extends StatelessWidget {
  String date;
  String statusText;
  String totalCost;

  OverviewHeader(this.date, this.statusText, this.totalCost, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(date,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      Text(statusText),
      Text(totalCost,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
    ]);
  }
}

class OverviewBriefs extends StatelessWidget {
  final List<InvoiceBrief> briefs;

  const OverviewBriefs(this.briefs, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        //todo: status color
        children: briefs.map((e) => OverviewCard(e.text)).toList(),
      ),
    );
  }
}
