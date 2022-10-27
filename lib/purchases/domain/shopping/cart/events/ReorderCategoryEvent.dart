import 'package:finance_controlinator_mobile/purchases/domain/shopping/cart/events/EventTypes.dart';

class ReorderCategoryEvent {
  String eventType = EventTypes.REORDER_CATEGORY;
  String shoppingId;
  String categoryId;
  int oldPosition;
  int newPosition;

  ReorderCategoryEvent(this.shoppingId, this.categoryId,
      this.oldPosition, this.newPosition);

  ReorderCategoryEvent.fromJson(Map<String, dynamic> json)
      : shoppingId = json['shoppingId'],
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
