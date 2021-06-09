class Trip {
  var orgRefName;
  var vehicleId;
  var vehicleNumber;
  var expectedTripStartTime;
  StartLocation startLocation;
  StartLocation endLocation;
  var isRecurring;

  var tripId;
  var active;
  var expectedDistanceInMeter;
  var expectedTimeInSeconds;
  var tripStarted;
  var message ;


  var tripStartDate;
  var tripEndDate;


  Trip(
      {this.orgRefName,
      this.vehicleId,
      this.vehicleNumber,
      this.expectedTripStartTime,
      this.startLocation,
      this.endLocation,
      this.isRecurring, this.tripId,this.active,this.expectedDistanceInMeter,this.expectedTimeInSeconds,this.tripStarted,this.tripStartDate,this.tripEndDate});

  Trip.fromJson(Map<String, dynamic> json) {
    print("working here 1");
    tripId = json['tripId'];
    orgRefName = json['orgRefName'];
    vehicleId = json['vehicleId'];
    vehicleNumber = json['vehicleNumber'];
    expectedTripStartTime = json['expectedTripStartTime'];
    startLocation = json['startLocation'] != null
        ? new StartLocation.fromJson(json['startLocation'])
        : null;
    endLocation = json['endLocation'] != null
        ? new StartLocation.fromJson(json['endLocation'])
        : null;
    active = json['active'];
    expectedDistanceInMeter = json['expectedDistanceInMeter'];
    expectedTimeInSeconds = json['expectedTimeInSeconds'];

    print("working here 2");
  }

  Trip.error(Map<String, dynamic> json){
    message = json["message"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgRefName'] = this.orgRefName;
    data['vehicleId'] = this.vehicleId;
    data['vehicleNumber'] = this.vehicleNumber;
    data['expectedTripStartTime'] = this.expectedTripStartTime;
    if (this.startLocation != null) {
      data['startLocation'] = this.startLocation.toJson();
    }
    if (this.endLocation != null) {
      data['endLocation'] = this.endLocation.toJson();
    }
    data['isRecurring'] = this.isRecurring;
    return data;
  }

  Trip.getTrip(Map<String, dynamic> json){
    vehicleId = json["vehicleId"];
    vehicleNumber = json['vehicleNumber'];
    tripId = json['tripId'];
    tripStartDate = json['tripStartDate'];
    tripEndDate = json['tripEndDate'];
    active = json['active'];
    tripStarted = json["tripStarted"];
  }

  Trip.startTrip(Map<String, dynamic> json){
    message = json["message"];
  }

  Trip.endTrip(Map<String,dynamic> json){
    message = json["message"];
  }

  Trip.updateTrip(Map<String,dynamic> json){
    message = json["message"];
  }

}

class StartLocation {
  var lng;
  var lat;
  var type;
  List<dynamic> coordinates;

  StartLocation({this.lng, this.lat,this.type, this.coordinates});

  StartLocation.fromJson(Map<String, dynamic> json) {
    lng = json['lng'];
    lat = json['lat'];
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lng'] = this.lng;
    data['lat'] = this.lat;
    return data;
  }
}
