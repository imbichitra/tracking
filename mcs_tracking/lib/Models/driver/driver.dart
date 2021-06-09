import 'package:mcs_tracking/Models/vehicle/vehicle.dart';

class Driver {
  int driverId;
  String driverName;
  String contactNumber;
  String whatsappnumber;
  String drivingLicence;

  List<Vehicle> vehicles = List<Vehicle>();

  Driver(
      {this.driverId,
        this.driverName,
        this.contactNumber,
        this.whatsappnumber,
        this.drivingLicence});

  Driver.fromJson(Map<String, dynamic> json) {
    driverId = json['driverId'];
    driverName = json['driverName'];
    contactNumber = json['contactNumber'];
    whatsappnumber = json['whatsappnumber'];
    drivingLicence = json['drivingLicence'];
  }

  Driver.fromJsonVehicleDriverMap(
      String driverName, int driverId, String driverContact) {
    this.driverName = driverName;
    this.driverId = driverId;
    this.contactNumber = contactNumber;
  }

  Driver.vehicleDriverAssociation(Map<String, dynamic> json) {

    // print(json);
    this.driverId = json["driverId"];
    this.driverName = json["fullName"];
    this.contactNumber = json["contactNumber"];
    this.drivingLicence = json["drivingLicence"];
    this.whatsappnumber = json["whatsAppNumber"];
    this.vehicles = json["vehicles"]
        .map<Vehicle>((data) => Vehicle(
            vehicleType: data["vehicleType"],
            vehicleRegNumber: data["vehicleRegnNumber"],
            vehicleId: data["vehicleId"]))
        .toList();
    // print(this.vehicles.length);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.driverId != null) {
      data['driverId'] = this.driverId;
    }
    data['driverName'] = this.driverName;
    data['contactNumber'] = this.contactNumber;
    data['whatsappnumber'] = this.whatsappnumber;
    data['drivingLicence'] = this.drivingLicence;
    return data;
  }
}
