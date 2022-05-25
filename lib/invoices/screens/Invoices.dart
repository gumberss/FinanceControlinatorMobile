import 'dart:async';

import 'package:finance_controlinator_mobile/invoices/domain/sync/InvoiceSync.dart';
import 'package:finance_controlinator_mobile/invoices/services/InvoiceSyncService.dart';
import 'package:finance_controlinator_mobile/invoices/services/SyncStorageService.dart';

import 'package:flutter/material.dart';
import '../../expenses/components/OverviewCard.dart';
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
            body: Column(
              children: [InvoiceMonthDatasScreen(response.monthDataSyncs)],
            ),
          );
        }
        // },
        );
  }
}

class InvoiceMonthDatasScreen extends StatelessWidget {
  List<InvoiceMonthData> invoiceMonthDatas;

  InvoiceMonthDatasScreen(this.invoiceMonthDatas, {Key? key}) : super(key: key);

  //todo: do it for each of the list
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [InvoiceDataScreen(invoiceMonthDatas.first)],
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

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightBlue.shade100,
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
                    child: OverviewPartitions(overview.partitions)),
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
  List<InvoiceBrief> briefs;

  OverviewBriefs(this.briefs, {Key? key}) : super(key: key);

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

class OverviewPartitions extends StatelessWidget {
  List<InvoicePartition> partitions;

  OverviewPartitions(this.partitions, {Key? key}) : super(key: key);

  List<Color> colors = [
    Colors.redAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.orangeAccent,
    Colors.blueGrey,
    Colors.purpleAccent,
    Colors.deepOrangeAccent,
  ];

  @override
  Widget build(BuildContext context) {
    var descriptions = buildDescriptions(partitions, colors);

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: buildBar(partitions, colors)),
        Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: descriptions.take(4).toList())),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: descriptions.skip(4).take(4).toList())
      ],
    );
  }

  List<Row> buildDescriptions(
      List<InvoicePartition> parts, List<Color> colors) {
    return parts
        .asMap()
        .map((key, value) => MapEntry(
            key,
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Text(value.typeText + ":"),
                ),
                Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: colors[key],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))))
              ],
            )))
        .values
        .toList();
  }

//todo: make a component
  Row buildBar(List<InvoicePartition> parts, List<Color> colors) {
    var partitionsWithSpend =
        parts.where((element) => element.totalValue > 0).toList();

    return Row(
        children: partitionsWithSpend
            .asMap()
            .map((key, value) {
              return MapEntry(
                  key,
                  Expanded(
                      flex: value.percent.toInt(),
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                            color: colors[key],
                            borderRadius:
                                getBorder(key, partitionsWithSpend.length - 1)),
                      )));
            })
            .values
            .toList());
  }

//todo: be part of the component
  BorderRadius getBorder(int itemPosition, int lastPosition) {
    return itemPosition == 0
        ? const BorderRadius.only(
            topLeft: Radius.circular(6), bottomLeft: Radius.circular(6))
        : itemPosition == lastPosition
            ? const BorderRadius.only(
                topRight: Radius.circular(6), bottomRight: Radius.circular(6))
            : const BorderRadius.all(Radius.zero);
  }
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
