import 'ShoppingCategory.dart';

class ShoppingList {
  List<ShoppingCategory> categories;

  ShoppingList.fromJson(Map<String, dynamic> json)
      : categories = (json['categories'] as List)
      .map((e) => ShoppingCategory.fromJson(e))
      .toList(growable: true);

  Map<String, dynamic> toJson() => {
    'categories': categories.map((e) => e.toJson()).toList(),
  };
}
