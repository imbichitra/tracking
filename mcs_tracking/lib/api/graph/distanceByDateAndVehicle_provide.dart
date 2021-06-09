import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/graph/distanceByDateAndVehicle.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';

class DistanceByDateAndVehicleProvide{
  Dio _dio;


  DistanceByDateAndVehicleProvide(this._dio);

  Future<DistanceByDateAndVehicle> getDistanceByDate(data)async{
    try{
      final response = await _dio.post(
          GET_DISTANCE_BY_DATE_AND_VEHICLE,
          data: data
      );

      if(response.statusCode == 200){
        DistanceByDateAndVehicle distanceByDateAndVehicle = DistanceByDateAndVehicle.fromJson(response.data);
        return distanceByDateAndVehicle;
      }
    }catch(e){
      throw CustomeException(e);
    }

  }



}