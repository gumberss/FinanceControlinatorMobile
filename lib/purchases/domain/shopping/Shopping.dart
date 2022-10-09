class Shopping {
  String id;
  String place;
  String type;
  String title;
  String listId;
  String status;
  num? date;

  Shopping(this.id, this.place, this.type, this.title, this.listId, this.status);

  Shopping.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        place = json['place'],
        type = json['type'],
        title = json['title'],
        listId = json['listId'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'place': place,
        'type': type,
        'title': title,
        'listId': listId,
        'status': status,
      };
}
