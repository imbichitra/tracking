
import 'package:flutter/cupertino.dart';
import 'package:mcs_tracking/Models/driver/driver.dart';
import 'package:mcs_tracking/Models/vehicle/vehicle_owner.dart';




class Vehicle {
  /*String vehicleNo;
  String vehicleType;
  String ownerName;
  String ownerNumber;

  Vehicle.fromJson(Map<String, dynamic> json) {
    this.vehicleNo = json["vehicleRegNumber"];
    this.vehicleType = json["vehcleType"];
    this.ownerNumber = json["99006543967"];
    this.ownerName = json['ownerName'];
  }

  String get getVehicleNo => this.vehicleNo;
  String get getVehicleType => this.vehicleType;
  String get getOwnerName => this.ownerName;
  String get getOwnerNumber => this.ownerNumber;*/

  int vehicleId;
  String vehicleRegNumber;
  String vehicleType;
  String ownerName;
  String ownerContact;
  Vehicleowner vehicleowner;
  Driver driver;
  int deviceid;
  String imei;

  String createdAt;
  String updatedAt;

  Vehicle(
      {
        this.vehicleId,
      this.vehicleRegNumber,
      this.vehicleType,
      this.ownerName,
      this.ownerContact,
      this.vehicleowner,
      this.driver,
      this.deviceid,
      this.imei});

  Vehicle.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicleId'].toInt();
    vehicleRegNumber = json['vehicleRegnNumber'].toString()??" ";
    vehicleType = json['vehicleType'].toString()??" ";
    createdAt = json["createdAt"].toString()??" ";
    updatedAt = json["updatedAt"].toString()??" ";

    /*
    ownerName = json['ownerName'] != null ? json['ownerName'] : null;
    ownerContact = json['ownerContact'] != null ? json['ownerContact'] : null;
    vehicleowner = json['vehicleowner'] != null
        ? new Vehicleowner.fromJson(json['vehicleowner'])
        : null;
    driver =
        json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
    deviceid = json['deviceid'] != null ? json['deviceid'] : null;
    imei = json['imei'] != null ? json['imei'] : null;

    */
  }

//  for vehicle driver association

  Vehicle.fromJsonVehicleAssociation(Map<String, dynamic> json){
    vehicleId = json['vehicleid'];
    vehicleRegNumber = json['vehicleNumber'];
    vehicleType = json['vehicleType'];
    ownerName = json['ownerName'] != null ? json['ownerName'] : null;
    ownerContact = json['ownerContact'] != null ? json['ownerContact'] : null;
    if(json["driverid"] != null && json["driverName"] != null && json["driverContact"] != null){
      driver = Driver.fromJsonVehicleDriverMap(json["driverName"], json["deviceid"], json["driverContact"]);
    }else{
      driver = Driver.fromJsonVehicleDriverMap("na", 0, "na");
    }
    
    json['driver'] != null ? new Driver.fromJson(json['driver']) : null;
    deviceid = json['deviceid'] != null ? json['deviceid'] : null;
    imei = json['imeiNumber'] != null ? json['imei'] : null;

  }

  Vehicle.fromDeviceAssociation(json){
    vehicleId = json["vehicleid"] != null? json["vehicleid"]: 0;
    vehicleRegNumber= json["vehicleNumber"] !=null? json["vehicleNumber"]:"na" ;
    deviceid = json["deviceid"] != null? json["deviceid"]: 0;
    imei = json["imeiNumber"] != null? json["imeiNumber"]:"na";
    vehicleType = json["vehicleType"] != null? json["vehicleType"]:"na";

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.vehicleId != null){
      data['vehicleId'] = this.vehicleId;
    }
    data['vehicleRegNumber'] = this.vehicleRegNumber;
    data['vehicleType'] = this.vehicleType;
    data['ownerName'] = this.ownerName;
    data['ownerContact'] = this.ownerContact;
    if (this.vehicleowner != null) {
      data['vehicleowner'] = this.vehicleowner.toJson();
    }
    if (this.driver != null) {
      data['driver'] = this.driver.toJson();
    }
    if(this.deviceid != null){
      data['deviceid'] = this.deviceid;
    }
    if(this.imei != null){
      data['imei'] = this.imei;
    }
    return data;
  }


}

class OwnerDetails{
  String ownerName;
  String ownerContactNumber;
  String orgRefName;

  OwnerDetails.fromJson(Map<String,dynamic> json){
    this.orgRefName = json["orgRefName"];
    this.ownerName = json["ownerName"];
    this.ownerContactNumber = json["ownerContact"];
  }


}
