import 'ShoppingCategory.dart';

class ShoppingList {
  String shoppingId;
  List<ShoppingCategory> categories;

  ShoppingList.fromJson(Map<String, dynamic> json)
      : categories = (json['categories'] as List)
            .map((e) => ShoppingCategory.fromJson(e))
            .toList(growable: true),
        shoppingId = json['shoppingId'];

  ShoppingList.fromShoppingJson(Map<String, dynamic> json)
      : categories = (json['categories'] as List)
      .map((e) => ShoppingCategory.fromJson(e))
      .toList(growable: true),
        shoppingId = json['id'];

  Map<String, dynamic> toJson() => {
        'categories': categories.map((e) => e.toJson()).toList(),
        'shoppingId': shoppingId,
      };
}
