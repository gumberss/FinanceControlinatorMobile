import 'ShoppingItem.dart';

class ShoppingCategory {
  String? id;
  String name;
  int? orderPosition;
  String? purchaseListId;
  int color;
  List<ShoppingItem>? items;

  ShoppingCategory(this.id, this.name, this.purchaseListId, this.color);

  ShoppingCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        color = json['color'],
        purchaseListId = json['purchaseListId'],
        items = json['items']!= null ? (json['items'] as List)
            .map((e) => ShoppingItem.fromJson(e))
            .toList(growable: true) : null,
        orderPosition = json['orderPosition'] ?? 0;

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'color': color,
        'purchaseListId': purchaseListId,
        'orderPosition': orderPosition,
      };
}
