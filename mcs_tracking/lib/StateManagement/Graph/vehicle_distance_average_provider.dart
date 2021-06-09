import 'package:mcs_tracking/Models/graph/fleetDistanceVehicleAverage.dart';
import 'package:flutter/material.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/api/graph/vehicle_distance_average_repository.dart';

class VehicleDistanceAverageStateManagement extends ChangeNotifier{
  DistanceVehicleList _distanceVehicleList;
  VehicleDistanceAverageRepository _vehicleDistanceAverageRepository = VehicleDistanceAverageRepository();


  void setDistanceVehicleList(DistanceVehicleList object){
    this._distanceVehicleList = object;
    notifyListeners();
  }

  DistanceVehicleList get  getDistanceVehicleList => this._distanceVehicleList;

  Future<void> fetchVehicleDistanceAverage(data)async{
    try{
      DistanceVehicleList object = await _vehicleDistanceAverageRepository.getDistanceVehicleAverage(data);
      setDistanceVehicleList(object);

    }catch(e){
      throw CustomeException(e);
    }
  }

}