class ExpenseItem {
  String name;
  String description;
  double cost;
  int amount;
  String id;

  ExpenseItem(this.id, this.name, this.description, this.cost, this.amount);

  double totalCost() => cost * amount;

  ExpenseItem.fromJson(Map<String, dynamic> json)
      :
        id = json['id'],
        name = json['name'],
        description = json['description'],
        cost = json['cost'],
        amount = json['amount'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'description': description,
        'cost': cost,
        'amount': amount
      };

  static bool isValidProperties(String name, String description, double? cost,
      int? amount) {
    return name.isNotEmpty &&
        cost != null &&
        cost > 0 &&
        amount != null &&
        amount > 0;
  }
}
