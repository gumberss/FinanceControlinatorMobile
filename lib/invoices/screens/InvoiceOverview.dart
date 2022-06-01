import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../expenses/components/OverviewCard.dart';
import '../../expenses/components/OverviewSpendBar.dart';
import '../domain/sync/InvoiceSync.dart';

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
                    child: OverviewSpendBar(
                        overview.partitions
                            .map((e) => PartitionData(
                                e.type, e.typeText, e.percent, e.totalValue))
                            .toList(),
                        InvoiceItem.colors)),
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
      Text(totalCost,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
    ]);
  }
}

class OverviewBriefs extends StatelessWidget {
  final List<InvoiceBrief> briefs;

  OverviewBriefs(this.briefs, {Key? key}) : super(key: key);

  final List<Color> colors = [
    Colors.lightBlueAccent.shade200,
    Colors.redAccent.shade100,
    Colors.lightGreen.shade200,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: ListView(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: briefs
            .map((brief) =>
                OverviewCard(brief.text, color: colors[brief.status]))
            .toList(),
      ),
    );
  }
}
