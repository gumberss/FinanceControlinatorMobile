import 'package:finance_controlinator_mobile/expenses/domain/overviews/ExpensePartition.dart';
import 'package:flutter/material.dart';

class ExpenseSpendBar extends StatelessWidget {
  List<ExpensePartition> _partitions;

  ExpenseSpendBar(this._partitions, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _partitions.sort((x, y) => x.type.compareTo(y.type));
    var partitionsWithSpend =
        _partitions.where((element) => element.percent > 0).toList();

    List<Color> colors = [
      Colors.redAccent,
      Colors.greenAccent,
      Colors.blueAccent,
      Colors.orangeAccent,
      Colors.blueGrey,
      Colors.purpleAccent,
    ];

    var descriptions = getDescriptions(colors);

    return Column(
      children: [
        Row(
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
                                borderRadius: getBorder(
                                    key, partitionsWithSpend.length - 1)),
                          )));
                })
                .values
                .toList()),
        Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: descriptions.take(3).toList())),
        Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: descriptions.skip(3).take(3).toList()))
      ],
    );
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

  List<Row> getDescriptions(List<Color> colors) {
    return _partitions
        .asMap()
        .map((key, value) => MapEntry(
            key,
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Text(value.type + ":"),
                ),
                Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: colors[key],
                        borderRadius: const BorderRadius.all(const Radius.circular(100))))
              ],
            )))
        .values
        .toList();
  }
}
