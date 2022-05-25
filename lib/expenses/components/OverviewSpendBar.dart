
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PartitionData {
  int type;
  double percent;
  String typeText;
  num totalValue;
  PartitionData(this.type, this.typeText, this.percent, this.totalValue);
}

class OverviewSpendBar extends StatelessWidget {
  final List<PartitionData> partitions;

  OverviewSpendBar(this.partitions, {Key? key}) : super(key: key);

  final List<Color> colors = [
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
      List<PartitionData> parts, List<Color> colors) {
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

  Row buildBar(List<PartitionData> parts, List<Color> colors) {
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