import 'package:finance_controlinator_mobile/purchases/domain/shopping/cart/events/EventTypes.dart';

class ChangeItemEvent {
  String eventType = EventTypes.CHANGE_ITEM;
  String shoppingId;
  String id;
  String itemId;
  double price;
  int quantityChanged;

  ChangeItemEvent(
      this.id, this.shoppingId, this.itemId, this.price, this.quantityChanged);

  ChangeItemEvent.fromJson(Map<String, dynamic> json)
      : id = json['eventId'],
        shoppingId = json['shoppingId'],
        itemId = json['itemId'],
        price = json['price'],
        quantityChanged = json['quantityChanged'];

  Map<String, dynamic> toJson() => {
        'eventId': id,
        'eventType': eventType,
        'shoppingId': shoppingId,
        'itemId': itemId,
        'price': price,
        'quantityChanged': quantityChanged,
      };
}
