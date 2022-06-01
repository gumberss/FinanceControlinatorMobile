import 'package:finance_controlinator_mobile/expenses/domain/ExpenseItem.dart';

import 'ExpenseType.dart';

class Expense {
  String? id;
  String title;
  String description;
  String location;
  DateTime purchaseDate;
  ExpenseType type;

  double totalCost;
  int installmentsCount;

  String observation;

  List<ExpenseItem>? items;

  Expense(
      this.id,
      this.title,
      this.description,
      this.location,
      this.purchaseDate,
      this.type,
      this.totalCost,
      this.installmentsCount,
      this.observation,
      this.items);

  Expense.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        location = json['location'],
        purchaseDate = DateTime.parse(json['purchaseDate'].toString()),
        type = ExpenseType.from(json['type']),
        totalCost = json['totalCost'],
        installmentsCount = json['installmentsCount'],
        observation = json['observation'],
        items = (json['items'] as List?)
            ?.map((e) => ExpenseItem.fromJson(e))
            .toList(growable: false);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'location': location,
        'purchaseDate': purchaseDate.toString(),
        'type': type.value,
        'totalCost': totalCost,
        'installmentsCount': installmentsCount,
        'observation': observation,
        'items': items?.map((e) => e.toJson()).toList(),
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
