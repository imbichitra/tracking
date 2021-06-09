class DeviceList{
  List<Device> devices;
  DeviceList();
  DeviceList.fromJson(Map<String,dynamic> json){
    for (var data in json['data']){
     
      devices.add(Device(deviceId: data["deviceId"], imeiNumber: data["imeiNumber"],model: data['model']));
    }
    // devices = temp;
    print(devices);
  }

  List<Device> get getDevicesList => this.devices;

}



class Device{
  int deviceId;
  String imeiNumber;
  String model;


  Device({this.deviceId,this.imeiNumber, this.model});

  int get getDeviceID => this.deviceId;
  String get getImeiNumber => this.imeiNumber;
  String get getModel => this.model;

  void setDeviceId(int deviceID){
    this.deviceId = deviceID;
  }

  void setImeiNumber(String imei){
    this.imeiNumber = imei;
  }

  void setModel(String model){
    this.model = model;
  }



}