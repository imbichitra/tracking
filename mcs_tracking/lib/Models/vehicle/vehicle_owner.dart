class Vehicleowner {
  int vehicleownerId;
  String ownerName;
  String ownerContact;

  Vehicleowner({this.vehicleownerId, this.ownerName, this.ownerContact});

  Vehicleowner.fromJson(Map<String, dynamic> json) {
    vehicleownerId = json['vehicleownerId'];
    ownerName = json['ownerName'];
    ownerContact = json['ownerContact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleownerId'] = this.vehicleownerId;
    data['ownerName'] = this.ownerName;
    data['ownerContact'] = this.ownerContact;
    return data;
  }
}
