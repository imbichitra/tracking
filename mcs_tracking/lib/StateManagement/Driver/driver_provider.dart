import 'package:flutter/material.dart';
import 'package:mcs_tracking/api/driver/driver_repository.dart';
import 'package:mcs_tracking/Models/driver/driver.dart';

class DriverStateManagement extends ChangeNotifier{
  List<Driver> driverList = List();
  List<Driver> vehicleDriverAssociationList = List();
  bool isLoading = false;
  int statusCode;
  DriverRepository driverRepository = DriverRepository();


  DriverStateManagement();

  List<Driver> get getDriverList => this.driverList;
  List<Driver> get getVehicleDriverAssociationList => this.vehicleDriverAssociationList;

  void setDriverList(List<Driver> drivers){
    this.driverList = drivers;
    notifyListeners();
  }

  void setAssociateVehicleDriver(List<Driver> vehicleDriver){
    this.vehicleDriverAssociationList = vehicleDriver;
    notifyListeners();
  }

  Future<void> getDrivers()async{
    try{
      isLoading = true;
      notifyListeners();
      List<Driver> list = await driverRepository.getAllDriver();
      setDriverList(list);

    }catch(e){
      print(e);
    }
  }

  Future<int> addDriver(driver)async{

    try{
      isLoading = true;
      notifyListeners();
      print("working here");
      statusCode = await driverRepository.createDriver(driver);
      return statusCode;
    }catch(e){

    }
  }

  Future<int> updateDriver(driver)async {
    try {
      isLoading = true;
      notifyListeners();
      statusCode = await driverRepository.updateDriver(driver);
      return statusCode;
    } catch (e) {

    }
  }

    Future<int> deleteDriver(int driverId)async{
      try{
        isLoading = true;
        notifyListeners();
        statusCode = await driverRepository.deleteDriver(driverId);
        return statusCode;
      }catch(e){
        print(e);
      }
    }

    Future<void> getAssociateVehiclesAndDrive()async{
      try{
        isLoading = true;
        notifyListeners();
        List<Driver> list = await driverRepository.getAssociateVehicle();
        setAssociateVehicleDriver(list);

      }catch(e){

      }
    }

  }




