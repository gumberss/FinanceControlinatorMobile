import 'PurchaseCategory.dart';
import 'PurchaseItem.dart';

class PurchaseListManagementData {
  List<PurchaseCategory> categories;
  List<PurchaseItem> items;

  PurchaseListManagementData.fromJson(Map<String, dynamic> json)
      : categories = (json['categories'] as List)
      .map((e) => PurchaseCategory.fromJson(e))
      .toList(growable: true),
        items = (json['items'] as List)
            .map((e) => PurchaseItem.fromJson(e))
            .toList(growable: true);

  Map<String, dynamic> toJson() => {
    'categories': categories.map((e) => e.toJson()).toList(),
    'items': items.map((e) => e.toJson()).toList(),
  };
}
