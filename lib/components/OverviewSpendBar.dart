import 'package:flutter/material.dart';

class PartitionData {
  int type;
  double percent;
  String typeText;

  PartitionData(this.type, this.typeText, this.percent);
}

class OverviewSpendBar extends StatelessWidget {
  final List<PartitionData> partitions;
  final Map<int, Color> colors;

  const OverviewSpendBar(this.partitions, this.colors, {super.key});

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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: descriptions.skip(4).take(4).toList())
      ],
    );
  }

  List<Row> buildDescriptions(
      List<PartitionData> parts, Map<int, Color> colors) {
    return parts
        .map((e) => Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Text("${e.typeText}:"),
                ),
                Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: colors[e.type],
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100))))
              ],
            ))
        .toList();
  }

  Row buildBar(List<PartitionData> parts, Map<int, Color> colors) {
    var partitionsWithSpend =
        parts.where((element) => element.percent > 0).toList();

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
                            color: colors[value.type],
                            borderRadius:
                                getBorder(key, partitionsWithSpend.length - 1)),
                      )));
            })
            .values
            .toList());
  }

  BorderRadius getBorder(int itemPosition, int lastPosition) {
    return itemPosition == 0 && lastPosition == 0
        ? const BorderRadius.all(Radius.circular(6))
        : itemPosition == 0
            ? const BorderRadius.only(
                topLeft: Radius.circular(6), bottomLeft: Radius.circular(6))
            : itemPosition == lastPosition
                ? const BorderRadius.only(
                    topRight: Radius.circular(6),
                    bottomRight: Radius.circular(6))
                : const BorderRadius.all(Radius.zero);
  }
}
