
class FleetUsage{
  int totalDistance;
  int average;

  List<FleetUsageVehicleDetails> vehicles = List<FleetUsageVehicleDetails>();


  FleetUsage.fromJson(Map<String,dynamic> json){
    print("work here");
    print(json);

    this.totalDistance = json["totalDistance"];
    this.average = json["average"];


    for(var i in json["matrix"]){
      FleetUsageVehicleDetails obj = FleetUsageVehicleDetails(i);
      print(obj.distance);
      vehicles.add(obj);

    }

    // for(var i in vehicles){
    //   print(i.vehicleNumber);
    // }
  }


}


class FleetUsageVehicleDetails{
  String vehicleNumber;
  String driverName;
  double distance;

  FleetUsageVehicleDetails(Map<String,dynamic> json){
    this.vehicleNumber = json["vehicleNumber"];
    this.distance = json["distance"].toDouble();
    this.driverName = json["driverName"];

  }
}