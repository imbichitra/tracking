
import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/vehicle/vehicle.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/api/vehicle/vehicle_repository.dart';

class VehicleStateManagement extends ChangeNotifier {
  List<Vehicle> vehicleList = List();
  List<Vehicle> vehicleDriverMapList = List();
  List<Vehicle> vehicleDeviceMapList = List();

  OwnerDetails _ownerDetails;


  VehicleRepository vehicleRepository = VehicleRepository();
  bool isLoading = false;
  int statusCode;

  VehicleStateManagement(){
//    getAllVehicles();
  }

  setVehicleDriverMap(List<Vehicle> vehicleDriverMaps){
    this.vehicleDriverMapList = vehicleDriverMaps;
//    print(vehicleDriverMaps);
    notifyListeners();
  }

  setVehicleDeviceMap(List<Vehicle> vehicleDeviceMaps){
    this.vehicleDeviceMapList = vehicleDeviceMaps;
    notifyListeners();
  }

  setVehicles(List<Vehicle> vehicles) {
    this.vehicleList = vehicles;
    notifyListeners();
  }

  setOwnerDetails(OwnerDetails ownerDetails){
    this._ownerDetails = ownerDetails;
    notifyListeners();
  }


  List<Vehicle> get getVehicles => this.vehicleList;
//  int get getStatusCode => this.statusCode;

  List<Vehicle> get getVehicleDriverMapList => this.vehicleDriverMapList;

  List<Vehicle> get getVehicleDeviceMapList =>  this.vehicleDeviceMapList;

  OwnerDetails get getOwnerDetails => this._ownerDetails;




  Future<void> getAllVehicles() async{
    try {
      isLoading = true;
      List<Vehicle> list = await vehicleRepository.getAllVehicle();
      setVehicles(list);
//      notifyListeners();
      }catch(e){
      print(e);
    }
  }


  Future<int> updateVehicles(vehicle)async{
    try{
      isLoading = true;
      notifyListeners();
      print('working------------>');
      statusCode = await vehicleRepository.updateVehicl(vehicle);
//      notifyListeners();
    return statusCode;
    }catch(e){
      print(e);
    }
  }

  Future<int> deleteVehicle(int vehicleId)async{
    try{
      isLoading = true;
      notifyListeners();
      statusCode = await vehicleRepository.deleteVehicle(vehicleId);
      return statusCode;
    }catch(e){
      print(e);
    }
  }

  Future<int>  createVehicle(vehicle) async{
    try{
      isLoading = true;
      notifyListeners();
      statusCode = await vehicleRepository.createVehicle(vehicle);
      return statusCode;
    }catch(e){
      print(e);
    }
  }

  // Future<void> getVehicleDriverMap()async{
  //   try{
  //     List<Vehicle> list = await vehicleRepository.getVehicleDriverMap();
  //     setVehicleDriverMap(list);
  //   }catch(e){
  //     print(e);
  //   }
  // }

  // Future<void> getVehicleDeviceMap()async{
  //   try{
  //     List<Vehicle> list = await vehicleRepository.getVehicleDeviceMap();
  //     setVehicleDeviceMap(list);
  //   }catch(e){
  //     print(e);
  //   }
  // }

  Future<int> associateVehicleDriver(object) async{
    try{
      statusCode = await vehicleRepository.associateVehicleWithDriver(object);
      return statusCode;
    }catch(e){
      print(e);
    }
  }

  Future<int> associateVehicleDevice(object) async{
    try{
      statusCode = await vehicleRepository.associateVehicleWithDevice(object);
      return statusCode;
    }catch(e){
      print(e);
    }
  }

  Future<void> fetchOwnerDetails(int id)async{
    try{
      OwnerDetails ownerDetails = await vehicleRepository.getOwnerDetails(id);
      setOwnerDetails(ownerDetails);
    }catch(e){
      print(e);
      throw CustomeException(e);
    }
  }


}
