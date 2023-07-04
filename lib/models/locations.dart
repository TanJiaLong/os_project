class Locations {
  String? locationId;
  String? userId;
  String? latitude;
  String? longitude;
  String? state;
  String? locality;
  String? checkInDate;

  Locations(
      {this.locationId,
      this.userId,
      this.latitude,
      this.longitude,
      this.state,
      this.locality,
      this.checkInDate});

  Locations.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'];
    userId = json['user_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    state = json['state'];
    locality = json['locality'];
    checkInDate = json['check_in_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationId;
    data['user_id'] = this.userId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['state'] = this.state;
    data['locality'] = this.locality;
    data['check_in_date'] = this.checkInDate;
    return data;
  }
}
