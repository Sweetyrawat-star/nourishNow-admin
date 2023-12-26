class AddressModel {
   String? address;
   String? latitude;
   String? longitude;

  AddressModel(
      {
      required this.address,
      required this.latitude,
      required this.longitude,
     });

  AddressModel.fromJson(Map<String, dynamic> json) {
      latitude = json['latitude']??"";
      longitude = json['longitude']??"";
      address = json['address']??"";
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }
}
