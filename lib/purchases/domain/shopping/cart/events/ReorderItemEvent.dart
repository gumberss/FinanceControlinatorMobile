import 'package:finance_controlinator_mobile/purchases/domain/shopping/cart/events/EventTypes.dart';

class ReorderItemEvent {
  String eventType = EventTypes.REORDER_ITEM;
  String id;
  String shoppingId;
  String newCategoryId;
  String itemId;
  int newPosition;

  ReorderItemEvent(this.id, this.shoppingId, this.itemId, this.newCategoryId,
      this.newPosition);

  ReorderItemEvent.fromJson(Map<String, dynamic> json)
      : id = json['eventId'],
        shoppingId = json['shoppingId'],
        itemId = json['itemId'],
        newCategoryId = json['newCategoryId'],
        newPosition = json['newPosition'];

  Map<String, dynamic> toJson() => {
        'eventId': id,
        'eventType': eventType,
        'shoppingId': shoppingId,
        'itemId': itemId,
        'newCategoryId': newCategoryId,
        'newPosition': newPosition,
      };
}
