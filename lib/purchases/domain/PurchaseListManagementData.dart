import 'PurchaseCategory.dart';

class PurchaseListManagementData {
  List<PurchaseCategory> categories;

  PurchaseListManagementData.fromJson(Map<String, dynamic> json)
      : categories = (json['categories'] as List)
            .map((e) => PurchaseCategory.fromJson(e))
            .toList(growable: true);

  Map<String, dynamic> toJson() => {
        'categories': categories.map((e) => e.toJson()).toList(),
      };
}
