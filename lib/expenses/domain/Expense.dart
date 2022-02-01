import 'package:finance_controlinator_mobile/expenses/domain/ExpenseItem.dart';

import 'ExpenseType.dart';

class Expense {
  String? id;
  String title;
  String description;
  String location;
  DateTime purchaseDay;
  ExpenseType type;

  double totalCost;
  int installmentCount;

  String observation;

  List<ExpenseItem> items;

  Expense(
      this.title,
      this.description,
      this.location,
      this.purchaseDay,
      this.type,
      this.totalCost,
      this.installmentCount,
      this.observation,
      this.items);

  Expense.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        location = json['location'],
        purchaseDay = json['purchaseDay'],
        type = json['type'],
        totalCost = json['totalCost'],
        installmentCount = json['installmentCount'],
        observation = json['observation'],
        items = json['items'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'location': location,
        'purchaseDay': purchaseDay,
        'type': type,
        'totalCost': totalCost,
        'installmentCount': installmentCount,
        'observation': observation,
        'items': items.map((e) => e.toJson()),
      };

  static bool areValidProperties(
      String title,
      String description,
      String location,
      DateTime purchaseDay,
      ExpenseType type,
      double? totalCost,
      int? installmentCount,
      String observation,
      List<ExpenseItem> items) {
    return title.isNotEmpty &&
        location.isNotEmpty &&
        totalCost != null &&
        totalCost > 0 &&
        installmentCount != null &&
        installmentCount > 0;
  }
}
