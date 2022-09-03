import 'package:flutter/material.dart';
import "package:collection/collection.dart";

class ExpandableCategoryList<TCategory, TItem> extends StatelessWidget {
  final List<TItem> items;
  final List<TCategory> categories;
  final ListTile Function(TItem) buildItem;
  final String? Function(TItem) groupProperty;
  final ListTile Function(TCategory)? buildDefaultTile;
  final String Function(TCategory) categoryGroupItemsProperty;
  final String Function(TCategory) categoryTitle;

  const ExpandableCategoryList(
      {Key? key,
      required this.items,
      required this.buildItem,
      required this.groupProperty,
      required this.categories,
      required this.categoryGroupItemsProperty,
      required this.categoryTitle,
      this.buildDefaultTile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var groupedItems = groupBy(items, groupProperty).map(buildItemTile).entries;

    var expandableTiles = categories
        .map((e) => buildExpansionTile(
            e,
            groupedItems
                    .firstWhereOrNull(
                        (x) => x.key == categoryGroupItemsProperty(e))
                    ?.value ??
                []))
        .toList();

    return ListView(children: expandableTiles);
  }

  MapEntry<String?, List<ListTile>> buildItemTile(
      String? key, List<TItem> values) {
    return MapEntry(key, values.map(buildItem).toList());
  }

  ExpansionTile buildExpansionTile(TCategory category, List<ListTile> entries) {
    var itemsTiles = buildDefaultTile != null
        ? [...entries, buildDefaultTile!(category)]
        : [...entries];
    return ExpansionTile(
        title: Text(categoryTitle(category)), children: itemsTiles);
  }
}

class BasicTile<T> {
  final String title;
  final List<T> items;

  const BasicTile({required this.title, this.items = const []});
}
