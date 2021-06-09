import 'package:dio/dio.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/Models/graph/distanceByVehicle.dart';

class DistanceByVehicleProvide{

  Dio _dio;

  DistanceByVehicleProvide(this._dio);

  Future<DistanceByVehicle> fetchDistanceByVehicle(data) async{
    try{
      final response = await _dio.post(
        GET_DISTANCE_BY_VEHICLE,
        data: data
      );

      DistanceByVehicle distanceByVehicle = DistanceByVehicle.fromJson(response.data);

     return distanceByVehicle;
    }catch(e){
      throw CustomeException(e);
    }
  }
}