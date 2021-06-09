import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/graph/fleetanalytics.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';

class AnalyticsProvide{
  Dio _dio;


  AnalyticsProvide(Dio dio){
    _dio = dio;
  }



  Future<FleetAnalytics> getUnderutilizedVehicles(String orgRefName)async{
      try{
        final response = await _dio.get(
          GET_UNDERUTILIZED_VEHICLE+orgRefName,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );

        FleetAnalytics fleetAnalytics = FleetAnalytics.underUtilized(response.data);
        return  fleetAnalytics;
      }catch(e){
        throw CustomeException(e);
      }
  }
  
  
  Future<FleetAnalytics> getOverSpeedVehicles(String orgRefName)async{
    try{
      final response = await _dio.get(
        GET_OVER_SPEED_VEHICLE+orgRefName,
        options: Options(
          headers:{
            'Content-Type': 'application/json',
          }
        )
      );

      FleetAnalytics fleetAnalytics = FleetAnalytics.overSpeed(response.data);
      return fleetAnalytics;
    }catch(e){
      throw CustomeException(e);
    }
  }

  Future<FleetAnalytics> getUnderSpeedVehicles(String orgRefName)async{
    try{
      final response = await _dio.get(
          GET_UNDER_SPEED_VEHICLE+orgRefName,
          options: Options(
              headers:{
                'Content-Type': 'application/json',
              }
          )
      );

      FleetAnalytics fleetAnalytics = FleetAnalytics.underSpeed(response.data);
      return fleetAnalytics;
    }catch(e){
      throw CustomeException(e);
    }
  }

  Future<FleetAnalytics> getLowFuelVehicles(String orgRefName)async{
    try{
      final response = await _dio.get(
          GET_UNDER_SPEED_VEHICLE+orgRefName,
          options: Options(
              headers:{
                'Content-Type': 'application/json',
              }
          )
      );

      FleetAnalytics fleetAnalytics = FleetAnalytics.underSpeed(response.data);
      return fleetAnalytics;
    }catch(e){
      throw CustomeException(e);
    }
  }

}