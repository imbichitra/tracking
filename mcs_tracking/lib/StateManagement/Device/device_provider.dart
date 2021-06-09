import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/device/device.dart';
import 'package:mcs_tracking/api/device/device_repository.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';


class DeviceStateManagement extends ChangeNotifier{
    List<Device> deviceList = List();
    List<Device> deviceVehicleAsscciationList = List();

    bool isLoading = false;
    DeviceRepository deviceRepository = DeviceRepository();
    int statusCode;

    DeviceStateManagement();

    void setDeviceList(List<Device> devices){
      this.deviceList = devices;
      notifyListeners();
    }

    void setDeviceVehicleAssociationList(List<Device> data){
      this.deviceVehicleAsscciationList = data;
      // isLoading = false;/
      notifyListeners();
    }



    List<Device> get getDevices => this.deviceList;
    List<Device> get getDeviceVehicleAssociationList => this.deviceVehicleAsscciationList;
    bool get getLoading => this.isLoading;


    Future<void> getAllDevices()async{
      try{
        isLoading = true;
        notifyListeners();
        List<Device> devices = await deviceRepository.getAllDevice();
        setDeviceList(devices);
      }catch(e){
        print(e);
      }

    }

    Future<int> addDevice(device) async{
      try{
        isLoading = true;
        notifyListeners();
        statusCode = await deviceRepository.createDevice(device);
        isLoading = false;
        notifyListeners();
        return statusCode;
      }catch(e){
        print(e);
      }
    }

    Future<int> updateDevice(device)async{
      try{
        isLoading = true;
        notifyListeners();
        statusCode = await deviceRepository.updateDevice(device);
        isLoading = false;
        notifyListeners();
        return statusCode;
      }catch(e){
        print(e);
      }
    }

    Future<int> deleteDevice(deviceId)async{
      try{
        isLoading = true;
        notifyListeners();
        statusCode = await deviceRepository.deleteDevice(deviceId);
        isLoading = false;
        notifyListeners();
        return statusCode;
      }catch(e){
        print(e);
      }
    }

    Future<void> getAssociateDeviceVehicle()async{
      try{
        List<Device> data = await deviceRepository.getAssociateDeviceVehicle();
        setDeviceVehicleAssociationList(data);

      }catch(e){
        throw CustomeException(e);
      }
    }



  }

