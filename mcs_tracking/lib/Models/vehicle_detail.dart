import 'package:intl/intl.dart';

import '../global.dart';

class VehicleDetail {
  var vehicleNumber;
  var vehicleType;
  var imeiNumber;
  var lng;
  var lat;
  var current;
  var driverName;
  var driverContact;
  var dateTimestamp;
  var lastTime;
  var fuel;
  var speed;
  var distance;
  var orgRefName;
  var topSpeed;
  var averageSpeed;
  var currentFuel;
  var idleEngineOff;
  var idleEngineOn;
  var vehicleMovingFlag;
  var alertFlag;
  var currentFlag;
  var geoViolation;
  var speedViolation;
  var totalDailyDistance;
  var calculatedDailyDistance;
  var calculatedSpeed;

  static VehicleDetail vehicleDetail;

  VehicleDetail(
      {this.vehicleNumber,
      this.vehicleType,
      this.imeiNumber,
      this.lng,
      this.lat,
      this.current,
      this.driverName,
      this.driverContact,
      this.dateTimestamp,
      this.fuel,
      this.speed,
      this.distance,
      this.orgRefName,
      this.topSpeed,
      this.averageSpeed,
      this.currentFlag,
      this.currentFuel,
      this.idleEngineOn,
      this.idleEngineOff,
      this.vehicleMovingFlag,
      this.alertFlag,
      this.geoViolation,
      this.speedViolation,
      this.calculatedDailyDistance,
      this.calculatedSpeed});

  factory VehicleDetail.fromJson(Map<String, dynamic> json) {
    print("inside..........vehicle details");
    print(json);
    // {vehicleNumber: OD33S3028, imeiNumber: 867584035018865, lng: 85.836319, lat: 20.363928, vehicleType: CAR, lastTime: 1610386381000, driverName:
    // Sridhar, driverContact: 8908726955, orgRefName: mcs, totalDistanceDaily: 0.0, topSpeed: 2.0, current: true, speed: 0, fuel: 0, currentFuel: 0.0, idleEngineOn: fal
    // se, idleEngineOff: false, vehicleMovingFlag: false, alertFlag: false, currenFlag: true, geoViolation: false, speedViolation: false}

    return VehicleDetail(
        vehicleNumber: json['vehicleNumber'],
        vehicleType: json['vehicleType'],
        imeiNumber: json['imeiNumber'],
        lng: json['lng'],
        lat: json['lat'],
        current: json['current'],
        driverName: json['driverName'],
        driverContact: json['driverContact'],
        dateTimestamp: json['lastTime'] != null? timeStampToLocalTime(json['lastTime'].toInt()):" ",
        fuel: json['fuel'],
        speed: json['speed'] ?? 0,
        distance: json["totalDistanceDaily"] ?? 0,
        orgRefName: json["orgRefName"],
        topSpeed: json['topSpeed'] ?? 0,
        averageSpeed: json["averageSpeed"] == null ? 0 : json["averageSpeed"],
        calculatedDailyDistance: json["calculatedDailyDistance"] ?? 0,
        calculatedSpeed: json["calculatedSpeed"] ?? 0,
        currentFlag: json["currenFlag"],
        currentFuel: json["currentFuel"],
        idleEngineOn: json["idleEngineOn"],
        idleEngineOff: json["idleEngineOff"],
        vehicleMovingFlag: json["vehicleMovingFlag"],
        alertFlag: json["alertFlag"],
        geoViolation: json["geoViolation"],
        speedViolation: json["speedViolation"]);
  }

  factory VehicleDetail.fromJsonSocket(Map<String, dynamic> json) {
    print("inside vehicle from json Socket function");
    print(json);
    /*if(vehicleDetail == null){
      vehicleDetail = VehicleDetail(
        vehicleNumber : json['vehicleNumber'],
        vehicleType : json['vehicleType'],
        imeiNumber : json['imeiNumber'],
        lng : json['lng'],
        lat : json['lat'],
        current : json['current'],
        driverName : json['driverName'],
        driverContact : json['driverContact'],
        dateTimestamp : json['dateTimestamp'],
        fuel : json['fuel'],
        speed : json['speed'],
        distance :json['distance'],
        orgRefName : json['orgRefName'],
      );
    }else{
      vehicleDetail.vehicleNumber = json['vehicleNumber'];
      vehicleDetail.vehicleType = json['vehicleType'];
      vehicleDetail.imeiNumber = json['imeiNumber'];
      vehicleDetail.lng = json['lng'];
      vehicleDetail.lat = json['lat'];
      vehicleDetail.current = json['current'];
      vehicleDetail.driverName = json['driverName'];
      vehicleDetail.driverContact = json['driverContact'];
      vehicleDetail.dateTimestamp = json['dateTimestamp'];
      vehicleDetail.fuel = json['fuel'];
      vehicleDetail.speed = json['speed'];
      vehicleDetail.distance =json['distance'];
      vehicleDetail.orgRefName = json['orgRefName'];
    }*/
    return VehicleDetail(
        vehicleNumber: json['vehicleNumber'],
        vehicleType: json['vehicleType'],
        imeiNumber: json['imeiNumber'],
        lng: json['lng'],
        lat: json['lat'],
        // current: json['current'],
        driverName: json['driverName'],
        driverContact: json['driverContact'],
        dateTimestamp: json['dateTimestamp']!=null?DateFormat.yMMMMEEEEd().format(DateTime.parse(json['dateTimestamp'].toString())):" ",
        fuel: json['fuel'],
        speed: json['speed'],
        distance: json['distance'],
        orgRefName: json['orgRefName'],
        calculatedDailyDistance: json["calculatedDailyDistance"],

        topSpeed: json["topSpeed"],
        calculatedSpeed: json["calculatedSpeed"],
        averageSpeed: json["averageSpeed"],

        idleEngineOn: json["idleEngineOn"],
        idleEngineOff: json["idleEngineOff"],
        vehicleMovingFlag: json["vehicleMovingFlag"],
        alertFlag: json["alertFlag"],
        currentFlag: json["currentFlag"]
    );

    // {imeiNumber: 867584035024988, lat: 20.344328, lng: 85.825775, heading: 234, fuel: 0, vehicleNumber: OR02BB8732, vehicleType: CAR, driverName: S
    // ritam, driverContact: 7978928000, orgRefName: mcs, calculatedSpeed: 0.0, averageSpeed: 0.1, calculatedDailyDistance: 5.89, topSpeed: 54, idleEngineOn: false, idle
    // EngineOff: true, vehicleMovingFlag: false, alertFlag: false, currentFlag: true, delayedMessageFlag: false, dateTimestamp: 2021-01-26T09:52:39.000+00:00}

  }

  factory VehicleDetail.updateObject(
      VehicleDetail vehicleDetail, Map<String, dynamic> json) {
    print("############################################################ \n\n");
    print("inside update Object");
    print(json);
    vehicleDetail.vehicleNumber = json['vehicleNumber'];
    vehicleDetail.vehicleType = json['vehicleType'];
    vehicleDetail.imeiNumber = json['imeiNumber'];
    vehicleDetail.lng = json['lng'];
    vehicleDetail.lat = json['lat'];
    vehicleDetail.current = json['current'];
    vehicleDetail.driverName = json['driverName'];
    vehicleDetail.driverContact = json['driverContact'];
    vehicleDetail.dateTimestamp = json['dateTimestamp']!=null?DateFormat.yMMMMEEEEd().format(DateTime.parse(json['dateTimestamp'].toString())):" ";
    vehicleDetail.fuel = json['fuel'];
    vehicleDetail.speed = json['speed']??0;
    vehicleDetail.distance = json['distance']??0;
    vehicleDetail.orgRefName = json['orgRefName'];
    vehicleDetail.calculatedDailyDistance = json["calculatedDailyDistance"];
    vehicleDetail.calculatedSpeed = json["calculatedSpeed"];
    vehicleDetail.averageSpeed =
        json["averageSpeed"] == null ? 0 : json["averageSpeed"];
    vehicleDetail.topSpeed = json["topSpeed"]??0;
    vehicleDetail.idleEngineOn = json["idleEngineOn"];
    vehicleDetail.idleEngineOff = json["idleEngineOff"];
    vehicleDetail.alertFlag = json["alertFlag"];
    vehicleDetail.currentFlag = json["currentFlag"];
    return vehicleDetail;
  }
  // {imeiNumber: 867584035024988, lat: 20.344328, lng: 85.825775, heading: 234, fuel: 0, vehicleNumber: OR02BB8732, vehicleType: CAR, driverName: S
  // ritam, driverContact: 7978928000, orgRefName: mcs, calculatedSpeed: 0.0, averageSpeed: 0.1, calculatedDailyDistance: 5.89, topSpeed: 54, idleEngineOn: false, idle
  // EngineOff: true, vehicleMovingFlag: false, alertFlag: false, currentFlag: true, delayedMessageFlag: false, dateTimestamp: 2021-01-26T09:52:39.000+00:00}

}



