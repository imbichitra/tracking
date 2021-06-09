import 'dart:ui';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PinInformation {
  String pinPath;
  // String avatarPath;
  LatLng location;
  String deviceImei;
  String vehicleNumber;
  Color labelColor;
  String drivername;
  String dateTime;
// this.avatarPath,
  PinInformation({this.pinPath,  this.location, this.deviceImei, this.labelColor, this.vehicleNumber,this.drivername, this.dateTime});
}