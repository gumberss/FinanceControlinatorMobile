class PurchaseList {
  String? id;
  String name;
  bool inProgress;

  PurchaseList.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        inProgress = json['inProgress'] ?? false,
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'inProgress': inProgress,
      };
}
