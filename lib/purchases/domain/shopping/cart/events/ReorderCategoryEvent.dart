import 'package:finance_controlinator_mobile/purchases/domain/shopping/cart/events/EventTypes.dart';

class ReorderCategoryEvent {
  String eventType = EventTypes.REORDER_CATEGORY;
  String id;
  String shoppingId;
  String categoryId;
  int newPosition;

  ReorderCategoryEvent(this.id, this.shoppingId, this.categoryId, this.newPosition);

  ReorderCategoryEvent.fromJson(Map<String, dynamic> json)
      : id = json['eventId'],
        shoppingId = json['shoppingId'],
        categoryId = json['categoryId'],
        newPosition = json['newPosition'];

  Map<String, dynamic> toJson() => {
        'eventId': id,
        'eventType': eventType,
        'shoppingId': shoppingId,
        'categoryId': categoryId,
        'newPosition': newPosition,
      };
}
