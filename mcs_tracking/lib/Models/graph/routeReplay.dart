class RouteReplay {
  var vehicleNumber;
  var startDateTime;
  var endDateTime;

  int status;
  String message;
  Data data;

  RouteReplay({this.vehicleNumber, this.startDateTime, this.endDateTime, this.status, this.message, this.data});

  RouteReplay.fromJson(Map<String, dynamic> json) {
    print(json);
    this.status = json['status'];
    this.message = json['message'];
    print(message);
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleNumber'] = this.vehicleNumber;
    data['startDateTime'] = this.startDateTime;
    data['endDateTime'] = this.endDateTime;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }

    return data;
  }
}

class Data {
  var vehicleNumber;
  var avgSpeed;
  var avgmilage;
  var totalDistance;
  List<Locationlist> locationlist;
  var timeStamp;

  Data(
      {this.vehicleNumber,
      this.avgSpeed,
      this.avgmilage,
      this.totalDistance,
      this.locationlist,
      this.timeStamp});

  Data.fromJson(Map<String, dynamic> json) {
    this.vehicleNumber = json['vehicleNumber'];
    this.avgSpeed = json['avgSpeed'];
    this.avgmilage = json['avgmilage'];
    this.totalDistance = json['totalDistance'];
    if (json['locationlist'] != null) {
      locationlist = new List<Locationlist>();
      json['locationlist'].forEach((v) {
        locationlist.add(new Locationlist.fromJson(v));
      });
    }
    timeStamp = json['timeStamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicleNumber'] = this.vehicleNumber;
    data['avgSpeed'] = this.avgSpeed;
    data['avgmilage'] = this.avgmilage;
    data['totalDistance'] = this.totalDistance;
    if (this.locationlist != null) {
      data['locationlist'] = this.locationlist.map((v) => v.toJson()).toList();
    }
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}

class Locationlist {
  var lat;
  var lng;
  MessageTimeStamp messageTimeStamp;

  Locationlist({this.lat, this.lng, this.messageTimeStamp});

  Locationlist.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    messageTimeStamp = json['messageTimeStamp'] != null
        ? new MessageTimeStamp.fromJson(json['messageTimeStamp'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    if (this.messageTimeStamp != null) {
      data['messageTimeStamp'] = this.messageTimeStamp.toJson();
    }
    return data;
  }
}

class MessageTimeStamp {
  var nano;
  var year;
  var monthValue;
  var dayOfMonth;
  var hour;
  var minute;
  var second;
  var dayOfWeek;
  var dayOfYear;
  var month;
  Chronology chronology;

  MessageTimeStamp(
      {this.nano,
      this.year,
      this.monthValue,
      this.dayOfMonth,
      this.hour,
      this.minute,
      this.second,
      this.dayOfWeek,
      this.dayOfYear,
      this.month,
      this.chronology});

  MessageTimeStamp.fromJson(Map<String, dynamic> json) {
    nano = json['nano'];
    year = json['year'];
    monthValue = json['monthValue'];
    dayOfMonth = json['dayOfMonth'];
    hour = json['hour'];
    minute = json['minute'];
    second = json['second'];
    dayOfWeek = json['dayOfWeek'];
    dayOfYear = json['dayOfYear'];
    month = json['month'];
    chronology = json['chronology'] != null
        ? new Chronology.fromJson(json['chronology'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nano'] = this.nano;
    data['year'] = this.year;
    data['monthValue'] = this.monthValue;
    data['dayOfMonth'] = this.dayOfMonth;
    data['hour'] = this.hour;
    data['minute'] = this.minute;
    data['second'] = this.second;
    data['dayOfWeek'] = this.dayOfWeek;
    data['dayOfYear'] = this.dayOfYear;
    data['month'] = this.month;
    if (this.chronology != null) {
      data['chronology'] = this.chronology.toJson();
    }
    return data;
  }
}

class Chronology {
  var id;
  var calendarType;

  Chronology({this.id, this.calendarType});

  Chronology.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    calendarType = json['calendarType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['calendarType'] = this.calendarType;
    return data;
  }
}