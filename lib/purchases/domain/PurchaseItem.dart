class PurchaseItem {
  String? id;
  String name;
  int quantity;
  int? orderPosition;

  PurchaseItem(this.id, this.name) : quantity = 0;

  PurchaseItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        quantity = json['quantity'] ?? 0,
        orderPosition = json['orderPosition'] ?? 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'orderPosition': orderPosition,
      };
}
