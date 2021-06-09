

class FleetAnalytics{
  int lowFuelCount;
  int underUtilizedCount;
  int underSpeedCount;
  int overSpeedCount;

  List<VehicleAnalyticsDetail> underutilizedList = List<VehicleAnalyticsDetail>();

  List<VehicleAnalyticsDetail> lowFuelList = List<VehicleAnalyticsDetail>();

  FleetAnalytics();


  FleetAnalytics.underUtilized(Map<String,dynamic> json){
    this.underUtilizedCount = json["count"];
    for(var i in json["vehicleList"]){
      VehicleAnalyticsDetail obj = VehicleAnalyticsDetail(vehicleNumber: i["vehicleNumber"],driverName: i["driverName"],distanceTraveled: i["distanceTraveled"]);
      underutilizedList.add(obj);
    }
  }


  FleetAnalytics.fuel(Map<String,dynamic> json){
    this.lowFuelCount = json["count"];

    for(var i in json["vehicleDetails"]){
      VehicleAnalyticsDetail obj =  VehicleAnalyticsDetail.fuel(vehicleNumber: i["vehicleNumber"],driverName: i["driverName"],fuel: i["fuel"]);
      lowFuelList.add(obj);
    }
  }

  FleetAnalytics.underSpeed(Map<String,dynamic> json){
    this.underSpeedCount = json["count"];
  }

  FleetAnalytics.overSpeed(Map<String,dynamic> json){
    this.overSpeedCount = json["count"];
  }

  int get getUnderUtilisedCount => this.underUtilizedCount;
  int get getLowFuelCount =>this.lowFuelCount;
  int get getOverSpeedCount => this.overSpeedCount;
  int get getUnderSpeedCount => this.underSpeedCount;



  List<VehicleAnalyticsDetail> get getUnderUtilisedVehicles => this.underutilizedList;
  List<VehicleAnalyticsDetail> get getLowFuelVehicles => this.lowFuelList;



}


class VehicleAnalyticsDetail{

  String vehicleNumber;
  String driverName;
  double distanceTraveled;
  double fuel;


  VehicleAnalyticsDetail({this.vehicleNumber,this.driverName,this.distanceTraveled});

  VehicleAnalyticsDetail.fuel({this.vehicleNumber,this.driverName,this.fuel});

}