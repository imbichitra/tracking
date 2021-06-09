class FleetStatus{
    int totalVehicle;
    int runningVehicle;
    int idle;
    int stopped;
    int inactive;
    int noData;
    String timeStamp;


    FleetStatus();

    FleetStatus.fromJson(Map<String,dynamic> json){
      this.totalVehicle = json["totalVehicle"]??0;
      this.runningVehicle = json["runningVehicle"]??0;
      this.idle = json["idle"]??0;
      this.stopped = json["stopped"]??0;
      this.inactive = json["inactive"]??0;
      this.noData = json["noData"]??0;
      this.timeStamp = json["timeStamp"].toString()??" ";

      // print(runningVehicle);
    }

    int get getTotalVehicle => totalVehicle;
    int get getRunningVehicle => runningVehicle;
    int get getIdle => idle;
    int get getStopped => stopped;
    int get getInactive => inactive;
    int get getNoData => noData;
    String get getTimeStamp => timeStamp;

}