class ExpenseItem {
  String name;
  String description;
  double cost;
  int amount;

  ExpenseItem(this.name, this.description, this.cost, this.amount);

  double totalCost() => cost * amount;

  static bool isValidProperties(
      String name, String description, double? cost, int? amount) {
    return name.isNotEmpty &&
        cost != null &&
        cost > 0 &&
        amount != null &&
        amount > 0;
  }
}
