import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/graph/distanceByVehicle.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/api/graph/distanceByVehicle_repository.dart';


class DistanceByVehicleStateManagement extends ChangeNotifier{

  DistanceByVehicleRepository distanceByVehicleRepository = DistanceByVehicleRepository();

  DistanceByVehicle _distanceByVehicle;


  void setDistanceByVehicleData(DistanceByVehicle distanceByVehicle){
    _distanceByVehicle = distanceByVehicle;
    notifyListeners();
  }

  DistanceByVehicle get getDistanceByVehicle => this._distanceByVehicle;


  Future<void> fetchDistanceByVehicleData(data)async{
    try{
      DistanceByVehicle distanceByVehicle = await distanceByVehicleRepository.getDistanceByVehicle(data);
      setDistanceByVehicleData(distanceByVehicle);
    }catch(e){
      throw CustomeException(e);
    }
  }
  
}