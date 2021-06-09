class DistanceByVehicle {
  int timeStamp;
  List<Data> data;

  String orgRefName;
  String fromDate;
  String toDate;
  String vehicleNumber;

  DistanceByVehicle({this.timeStamp, this.data, this.orgRefName, this.fromDate,this.vehicleNumber, this.toDate});

  DistanceByVehicle.fromJson(Map<String, dynamic> json) {
    timeStamp = json['timeStamp'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgRefName'] = this.orgRefName;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;
    data['vehicleNumber'] = this.vehicleNumber;
    return data;
  }
}

class Data {
  int dateTimeStamp;
  int distance;

  Data({this.dateTimeStamp, this.distance});

  Data.fromJson(Map<String, dynamic> json) {
    dateTimeStamp = json['dateTimeStamp'];
    distance = json['distance'];
  }

}
