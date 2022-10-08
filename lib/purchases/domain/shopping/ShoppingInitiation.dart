class ShoppingInitiation {
  String? id;
  String? place;
  String? type;
  String? title;
  String? listId;
  double? latitude;
  double? longitude;

  ShoppingInitiation(this.id, this.place, this.type, this.title, this.listId,
      this.latitude, this.longitude);

  ShoppingInitiation.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        place = json['place'],
        type = json['type'],
        title = json['title'],
        listId = json['listId'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'place': place,
        'type': type,
        'title': title,
        'listId': listId,
        'latitude': latitude,
        'longitude': longitude,
      };
}
