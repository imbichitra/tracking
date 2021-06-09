
class DistanceVehicleList{
  List<DistanceVehicleAverage> result= List<DistanceVehicleAverage>();

    DistanceVehicleList.fromJson(json){
      print(json);
      for(var i in json){
        DistanceVehicleAverage object = DistanceVehicleAverage(i["vehicleNumber"], i["totalDistance"].toDouble(), i["averageDistance"].toDouble());
        print(object.vehicleNumber);
        this.result.add(object);
      }

      for(var i in result){
        print(i.totalDistance);
      }

    }

  List<DistanceVehicleAverage> get distancevehicleList => this.result;


}

class DistanceVehicleAverage{
    String _vehicleNumber;
    double _totalDistance;
    double _averageDistance;

    DistanceVehicleAverage(this._vehicleNumber,this._totalDistance,this._averageDistance);

    double get averageDistance => _averageDistance;

    set setAverageDistance(double value) {
      _averageDistance = value;
    }

    double get totalDistance => _totalDistance;

    set setTotalDistance(double value) {
      _totalDistance = value;
    }

    String get vehicleNumber => _vehicleNumber;

    set setVehicleNumber(String value) {
      _vehicleNumber = value;
    }


}