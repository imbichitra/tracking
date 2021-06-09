import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/graph/fleetDistanceVehicleAverage.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';


class VehicleDistanceAverageProvide{

  Dio _dio;

  VehicleDistanceAverageProvide(Dio dio){
    this._dio = dio;
  }


  Future<DistanceVehicleList> fetchVehicleDistance(data) async{
    try{
      final response = await _dio.post(
        GET_DISTANCE_VEHICLE_AVERAGE,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          }
        )
      );

      return DistanceVehicleList.fromJson(response.data);
    }catch(e){
      throw CustomeException(e);
    }
  }


}