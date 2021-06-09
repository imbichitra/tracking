import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/graph/distanceByDateAndVehicle.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/api/graph/distanceByDateAndVehicle_repository.dart';

class DistanceByDateAndVehicleStateManagement extends ChangeNotifier{
  DistanceByDateAndVehicleRepository _distanceByDateAndVehicleRepository = DistanceByDateAndVehicleRepository();
  DistanceByDateAndVehicle _distanceByDateAndVehicle;
  bool isLoading = true;

  void setdistanceByDateAndVehicle(DistanceByDateAndVehicle distanceByDateAndVehicle){
    _distanceByDateAndVehicle = distanceByDateAndVehicle;
    isLoading = false;
    notifyListeners();
  }

  DistanceByDateAndVehicle  get getDistanceByDateAndVehicle => this._distanceByDateAndVehicle;

  Future<void> fetchDistanceByDateAndVehicle(data)async{
    try{
     DistanceByDateAndVehicle distanceByDateAndVehicleObj = await _distanceByDateAndVehicleRepository.fetchDistanceByDateAndVehicle(data);
     setdistanceByDateAndVehicle(distanceByDateAndVehicleObj);
    }catch(e){
      throw CustomeException(e);
    }
  }

}

