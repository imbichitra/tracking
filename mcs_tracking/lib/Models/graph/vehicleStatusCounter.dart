import 'package:mcs_tracking/Models/vehicle/vehicle.dart';

class VehicleStatusCounterList{
  List<VehicleStatusCounter> list = [];

  VehicleStatusCounterList.fromJson(Map<String,dynamic> json){
    for(var i in json["data"]){
      VehicleStatusCounter obj = VehicleStatusCounter.fromJson(i);
      list.add(obj);
    }
  }

  List<VehicleStatusCounter> get getList => list;


}


class VehicleStatusCounter{
  double _activeVehicleCount;
  double _idleVehicleCount;
  String _dayOfMonth;

  VehicleStatusCounter.fromJson(Map<String,dynamic> json){
    print("---------------------->");
    print(json);
    this._activeVehicleCount = json["activeVehicleCount"].toDouble();
    this._idleVehicleCount = json["idleVehicleCount"].toDouble();
    this._dayOfMonth = json["dayOfMonth"];
  }

  double get activeVehicleCount => _activeVehicleCount;
  double get idleVehicleCount => _idleVehicleCount;
  String get dayOfMonth =>  _dayOfMonth;

}