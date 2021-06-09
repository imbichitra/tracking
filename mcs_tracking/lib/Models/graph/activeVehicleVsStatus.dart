class ActiveVehicleVsStatusList{
  List<ActiveVehicleVsStatus> list = [];

  ActiveVehicleVsStatusList.fromJson(Map<String,dynamic> json){
    for(var i in json["data"]){
      ActiveVehicleVsStatus obj = ActiveVehicleVsStatus.fromJson(i);
      this.list.add(obj);
    }
  }

  List<ActiveVehicleVsStatus> get getList => this.list;

}



class ActiveVehicleVsStatus{
  String _dayOfMonth;
  double _activeVehicleCount;
  double _totalDistance;

  ActiveVehicleVsStatus.fromJson(Map<String,dynamic> json){
    this._dayOfMonth = json["dayOfMonth"];
    this._activeVehicleCount = json["activeVehicleCount"].toDouble();
    this._totalDistance = json["totalDistance"].toDouble();
  }

  double get totalDistance => _totalDistance;

  double get activeVehicleCount => _activeVehicleCount;

  String get dayOfMonth => _dayOfMonth;
}

