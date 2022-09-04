import 'package:flutter/material.dart';
import "package:collection/collection.dart";

class ExpandableCategoryList<TCategory extends Object, TItem extends Object>
    extends StatelessWidget {
  final List<TItem> items;
  final List<TCategory> categories;
  final Draggable<TItem> Function(TItem) buildItem;
  final String? Function(TItem) itemGroupProperty;
  final Draggable<TCategory> Function(TCategory)? buildDefaultTile;
  final String Function(TCategory) categoryGroupItemsProperty;
  final ExpansionTile Function(TCategory, List<Draggable<Object>> items)
  buildCategoryTile;

  const ExpandableCategoryList({Key? key,
    required this.items,
    required this.buildItem,
    required this.itemGroupProperty,
    required this.categories,
    required this.categoryGroupItemsProperty,
    required this.buildCategoryTile,
    this.buildDefaultTile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var groupedItems =
        groupBy(items, itemGroupProperty)
            .map(buildItemTile)
            .entries;

    var expandableTiles = categories
        .map((e) =>
        buildExpansionTile(
            e,
            groupedItems
                .firstWhereOrNull(
                    (x) => x.key == categoryGroupItemsProperty(e))
                ?.value ??
                []))
        .toList();

    return ListView(children: expandableTiles);
  }

  MapEntry<String?, List<Draggable<TItem>>> buildItemTile(String? key,
      List<TItem> values) {
    return MapEntry(key, values.map(buildItem).toList());
  }

  ExpansionTile buildExpansionTile(TCategory category,
      List<Draggable<TItem>> entries) {
    var itemsTiles = buildDefaultTile != null
        ? [...entries, buildDefaultTile!(category)]
        : [...entries];

    return buildCategoryTile(category, itemsTiles);
  }
}

class BasicTile<T> {
  final String title;
  final List<T> items;

  const BasicTile({required this.title, this.items = const []});
}


class DraggableList {
  final String header;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.header,
    required this.items
  });
}

class DraggableListItem {
  final String title;
  final String urlImage;

  const DraggableListItem({
    required this.title,
    required this.urlImage
  });
}