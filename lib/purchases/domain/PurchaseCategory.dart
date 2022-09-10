
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