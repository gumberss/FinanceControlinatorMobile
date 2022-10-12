class ShoppingInitiationDataResponse {
  String? place;
  String? type;

  ShoppingInitiationDataResponse.fromJson(Map<String, dynamic> json)
      : place = json['place'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'place': place,
        'type': type,
      };
}
