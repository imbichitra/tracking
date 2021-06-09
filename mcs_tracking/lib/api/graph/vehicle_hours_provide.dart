
import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/graph/vehiclesHours.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
class VehicleHoursProvide{

  Dio _dio;

  VehicleHoursProvide(this._dio);

  Future<VehicleHoursList> fetchVehicleVsHpurs(data) async{
    try{
      final response = await _dio.post(
        GET_VEHICLE_VS_HOURS,
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          }
        )
      );
      return VehicleHoursList.fromJson(response.data);

    }catch(e){
     throw CustomeException(e);
    }
  }

}