class PurchaseItem {
  String? id;
  String name;
  int quantity;
  int orderPosition;
  String categoryId;
  String purchaseListId;

  PurchaseItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        quantity = json['quantity'] ?? 0,
        orderPosition = json['orderPosition'] ?? 0,
        purchaseListId = json['purchaseListId'],
        categoryId = json['categoryId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'orderPosition': orderPosition,
        'purchaseListId': purchaseListId,
        'category': categoryId,
      };
}

class PurchaseCategory {
  String? id;
  String name;
  int? orderPosition;
  String purchaseListId;
  int color;

  PurchaseCategory(
      this.id,
      this.name,
      this.purchaseListId,
      this.color);

  PurchaseCategory.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        color = json['color'],
        purchaseListId = json['purchaseListId'],
        orderPosition = json['orderPosition'] ?? 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
        'purchaseListId': purchaseListId,
        'orderPosition': orderPosition,
      };
}

class PurchaseListManagementData {
  List<PurchaseCategory> categories;
  List<PurchaseItem> items;

  PurchaseListManagementData.fromJson(Map<String, dynamic> json)
      : categories = (json['categories'] as List)
            .map((e) => PurchaseCategory.fromJson(e))
            .toList(growable: true),
        items = (json['items'] as List)
            .map((e) => PurchaseItem.fromJson(e))
            .toList(growable: true);

  Map<String, dynamic> toJson() => {
        'categories': categories.map((e) => e.toJson()).toList(),
        'items': items.map((e) => e.toJson()).toList(),
      };
}
