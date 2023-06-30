class PurchaseList {
  String? id;
  String name;
  bool inProgress;
  String userId;

  PurchaseList.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        inProgress = json['inProgress'] ?? false,
        name = json['name'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'inProgress': inProgress,
      };
}
