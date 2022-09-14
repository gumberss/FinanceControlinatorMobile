
import 'PurchaseItem.dart';

class PurchaseCategory {
  String? id;
  String name;
  int? orderPosition;
  String? purchaseListId;
  int color;
  List<PurchaseItem> items;

  PurchaseCategory(
      this.id,
      this.name,
      this.purchaseListId,
      this.color,
      this.items);

  PurchaseCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        color = json['color'],
        items = (json['purchaseItems'] as List)
            .map((e) => PurchaseItem.fromJson(e))
            .toList(growable: true),
        orderPosition = json['orderPosition'] ?? 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'color': color,
    'purchaseListId': purchaseListId,
    'purchaseItems': items.map((e) => e.toJson()).toList(),
    'orderPosition': orderPosition,
  };
}
