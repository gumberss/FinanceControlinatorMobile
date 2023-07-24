class ShoppingItem {
  String? id;
  String name;
  String categoryId;
  int quantity;
  int quantityInCart;
  int? orderPosition;
  num price;

  ShoppingItem(this.id, this.name, this.categoryId, this.price)
      : quantity = 0,
        quantityInCart = 0;

  ShoppingItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categoryId = json['categoryId'],
        quantity = json['quantity'] ?? 0,
        orderPosition = json['orderPosition'] ?? 0,
        quantityInCart = json['quantityInCart'] ?? 0,
        price =  json['price'] ?? 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'categoryId': categoryId,
        'quantity': quantity,
        'orderPosition': orderPosition,
        'price': price,
        'quantityInCart': quantityInCart
      };
}
