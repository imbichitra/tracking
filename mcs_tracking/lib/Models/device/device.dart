import 'package:mcs_tracking/Models/vehicle/vehicle.dart';

class Device {
  String imeiNumber;
  String modelType;
  int deviceId;
  String model;
  Vehicle vehicle;

  Device(
      {this.imeiNumber,
      this.modelType,
      this.deviceId,
      this.model,
      this.vehicle});

  Device.fromJson(Map<String, dynamic> json) {
    imeiNumber = json['imeiNumber'];
    modelType = json['modelType'] != null ? json['modelType'] : null;
    deviceId = json['deviceId'];
    model = json['model'];
    vehicle =
        json['vehicle'] != null ? new Vehicle.fromJson(json['vehicle']) : null;
  }

  Device.deviceVehicleAssociation(Map<String, dynamic> json) {
    print("**************************");
    print(json);
    this.imeiNumber = json["imeiNumber"];
    this.deviceId = json["deviceId"];
    this.modelType = json["model"];
    if(json["vehicle"] != null){
      this.vehicle = Vehicle(
          vehicleId: json["vehicle"]["vehicleId"],
          vehicleRegNumber: json["vehicle"]["vehicleRegnNumber"],
          vehicleType: json["vehicle"]["vehicleType"]);
    }else{
      this.vehicle = Vehicle(vehicleRegNumber: " ");
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imeiNumber'] = this.imeiNumber;
    data['modelType'] = this.modelType;
    /*data['deviceId'] = this.deviceId;
    data['model'] = this.model;
    if (this.vehicle != null) {
      data['vehicle'] = this.vehicle.toJson();
    }*/

    return data;
  }
}
