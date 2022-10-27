import 'package:finance_controlinator_mobile/purchases/domain/shopping/cart/events/EventTypes.dart';

class ReorderItemEvent {
  String eventType = EventTypes.REORDER_ITEM;

  String shoppingId;
  String newCategoryId;
  String itemId;
  int newPosition;

  ReorderItemEvent(
      this.shoppingId, this.itemId, this.newCategoryId, this.newPosition);

  ReorderItemEvent.fromJson(Map<String, dynamic> json)
      : shoppingId = json['shoppingId'],
        itemId = json['itemId'],
        newCategoryId = json['newCategoryId'],
        newPosition = json['newPosition'];

  Map<String, dynamic> toJson() => {
        'eventType': eventType,
        'shoppingId': shoppingId,
        'itemId': itemId,
        'newCategoryId': newCategoryId,
        'newPosition': newPosition,
      };
}
