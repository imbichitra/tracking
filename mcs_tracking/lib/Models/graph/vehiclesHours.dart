class VehicleHoursList {
  List<VehicleHours> result = List<VehicleHours>();

  VehicleHoursList.fromJson(json) {
    List<VehicleHours> copy = [];
    for (var i in json) {
      VehicleHours obj = VehicleHours(
          i["vehicleNumber"],
          i["idleHourEngineOn"].toDouble(),
          i["idleHourEngineOff"].toDouble(),
          i["movingEngineOn"].toDouble());

      copy.add(obj);
    }
    this.result = copy;
  }

  List<VehicleHours> get getVehicleHourList => this.result;
}

class VehicleHours {
  String _vehicleNumber;
  double _idleHourEngineOn;
  double _idleHourEngineOff;
  double _movingEngineOn;

  VehicleHours(this._vehicleNumber, this._idleHourEngineOn,
      this._idleHourEngineOff, this._movingEngineOn);

  double get movingEngineOn => _movingEngineOn;

  double get idleHourEngineOff => _idleHourEngineOff;

  double get idleHourEngineOn => _idleHourEngineOn;

  String get vehicleNumber => _vehicleNumber;
}
