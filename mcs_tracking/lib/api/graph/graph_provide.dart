import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mcs_tracking/Models/graph/activeVehicleVsStatus.dart';
import 'package:mcs_tracking/Models/graph/fleetStatus.dart';
import 'package:mcs_tracking/Models/graph/fleetUsage.dart';
import 'package:mcs_tracking/Models/graph/vehicleStatusCounter.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';

class GraphProvide{
  Dio _dio;

  GraphProvide(Dio dio){
    _dio = dio;
  }

  Future<FleetStatus> getFleetStatus(String orgRefName)async{
    try{
      final response = await _dio.get(
        GET_FLEET_STATUS+orgRefName,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      FleetStatus _fleetStatusObj = FleetStatus.fromJson(response.data);

      return _fleetStatusObj;

    }catch(e){
      throw CustomeException(e);
    }

  }

  Future<FleetUsage> getFleetUsage(String orgRefName) async{
    try{

      final response = await  _dio.get(
        GET_FLEET_USAGE+orgRefName,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          }
        )
      );

      FleetUsage fleetUsage = FleetUsage.fromJson(response.data);
       return fleetUsage;
    }catch(e){
      throw CustomeException(e);
    }
  }


  Future<VehicleStatusCounterList> getVehicleStatusCounter(var data)async{
    try{
      final response = await _dio.post(
          GET_VEHICLE_STATUS_COUNT,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          }
        )
      );

      return VehicleStatusCounterList.fromJson(response.data);
    }catch(e){
      throw CustomeException(e);
    }
  }

  Future<ActiveVehicleVsStatusList> getActiveVehicleVsStatus(var data) async{
    try{
      final response = await _dio.post(
          GET_ACTIVE_VEHICLE_VS_DISTANCE,
        data:data,
        options: Options(
          headers:{
            'Content-Type': 'application/json',
          }
        )
      );

      return ActiveVehicleVsStatusList.fromJson(response.data);
    }catch(e){
      throw CustomeException(e);
    }
  }
}