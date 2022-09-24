class PurchaseItem {
  String? id;
  String name;
  String categoryId;
  int quantity;
  int? orderPosition;

  PurchaseItem(this.id, this.name, this.categoryId) : quantity = 0;

  PurchaseItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categoryId = json['categoryId'],
        quantity = json['quantity'] ?? 0,
        orderPosition = json['orderPosition'] ?? 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'categoryId': categoryId,
        'quantity': quantity,
        'orderPosition': orderPosition,
      };
}
