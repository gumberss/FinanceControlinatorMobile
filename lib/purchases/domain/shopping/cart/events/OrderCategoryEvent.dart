class OrderCategoryEvent {
  String eventType;
  String shoppingId;
  String categoryId;
  int oldPosition;
  int newPosition;

  OrderCategoryEvent(this.eventType, this.shoppingId, this.categoryId,
      this.oldPosition, this.newPosition);

  OrderCategoryEvent.fromJson(Map<String, dynamic> json)
      : eventType = json['eventType'],
        shoppingId = json['shoppingId'],
        categoryId = json['categoryId'],
        oldPosition = json['oldPosition'],
        newPosition = json['newPosition'];

  Map<String, dynamic> toJson() => {
        'eventType': eventType,
        'shoppingId': shoppingId,
        'categoryId': categoryId,
        'oldPosition': oldPosition,
        'newPosition': newPosition,
      };
}
