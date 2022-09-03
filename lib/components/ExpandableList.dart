import 'package:flutter/material.dart';
import "package:collection/collection.dart";

class ExpandableList<T> extends StatelessWidget {
  final List<T> items;
  final ListTile Function(T) buildItem;
  final String? Function(T) groupProperty;

  const ExpandableList(
      {Key? key,
      required this.items,
      required this.buildItem,
      required this.groupProperty})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var expansionTiles = groupBy(items, groupProperty)
        .map(buildItemTile)
        .entries
        .map(buildExpansionTile)
        .toList();

    return ListView(children: expansionTiles);
  }

  MapEntry<String?, List<ListTile>> buildItemTile(String? key, List<T> values) {
    return MapEntry(key, values.map(buildItem).toList());
  }

  ExpansionTile buildExpansionTile(MapEntry<String?, List<ListTile>> entry) {
    return ExpansionTile(
        title: Text(entry.key ?? "No category"), children: entry.value);
  }
}

class BasicTile<T> {
  final String title;
  final List<T> items;

  const BasicTile({required this.title, this.items = const []});
}
