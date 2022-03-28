class ExpensePartition {
  String type;
  double percent;
  double totalValue;

  ExpensePartition.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        percent = json['percent'],
        totalValue = json['totalValue'];

  Map<String, dynamic> toJson() => {
        'type': type,
        'percent': percent,
        'totalValue': totalValue,
      };
}
