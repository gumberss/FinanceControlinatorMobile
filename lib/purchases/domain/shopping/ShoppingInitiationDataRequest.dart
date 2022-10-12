class ShoppingInitiationDataRequest {
  String? listId;
  double? latitude;
  double? longitude;

  ShoppingInitiationDataRequest(this.listId,
      this.latitude, this.longitude);

  ShoppingInitiationDataRequest.fromJson(Map<String, dynamic> json)
      : listId = json['listId'],
        latitude = json['latitude'],
        longitude = json['longitude'];

  Map<String, dynamic> toJson() => {
    'listId': listId,
    'latitude': latitude,
    'longitude': longitude,
  };
}
