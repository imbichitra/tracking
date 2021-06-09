class DistanceByDateAndVehicle {
  int timeStamp;
  List<Data> data;

  String orgRefName;
  String inputDate;

  DistanceByDateAndVehicle({this.timeStamp, this.data,this.orgRefName,this.inputDate});

  DistanceByDateAndVehicle.fromJson(Map<String, dynamic> json) {
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
    data['inputDate'] = this.inputDate;
    return data;
  }

}

class Data {
  String vehicleNumber;
  int distance;
  int messageCounter;

  Data({this.vehicleNumber, this.distance, this.messageCounter});

  Data.fromJson(Map<String, dynamic> json) {
    vehicleNumber = json['vehicleNumber'];
    distance = json['distance'];
    messageCounter = json['messageCounter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleNumber'] = this.vehicleNumber;
    data['distance'] = this.distance;
    data['messageCounter'] = this.messageCounter;
    return data;
  }
}