import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/driver/driver.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';

class DriverProvider{
  Dio _dio;

  DriverProvider(Dio dio) {
    _dio = dio;
  }
  Future<int> createDriver(driver) async {

    try {
      final response = await _dio.post(
        CREATE_DRIVER_URL,
        data: driver,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      print(response);
      return response.statusCode;//201
    } catch (e) {
      throw CustomeException(e);
    }
  }

   Future<int> updateDriver(driver) async {
    try {
      final response = await _dio.put(
        CREATE_DRIVER_URL,
        data: driver,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      return response.statusCode;//200
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<List<Driver>> getAllDriver() async {
    try {
      final response = await _dio.get(
        GET_DRIVERS_URL,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      return response.data.map<Driver>((json) => Driver.fromJson(json)).toList();
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<int>associateDriverWithVehicle(int vehicleId, int driverId) async {
     var data = jsonEncode({
      "vehicleId": vehicleId,
      "driverId":driverId
    });
    try {
      final response = await _dio.post(
        CREATE_ASSOCIATE_DRIVER_VEHICLE_URL,
        data: data,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      return response.statusCode;
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<int> deleteDriver(int driverId)async{
    try{
      final response = await _dio.delete(
          DELETE_DRIVER_URL+driverId.toString(),
        options: Options(
          headers: {
            'requirestoken': true,
          }
        )
      );
      return response.statusCode;

    }catch(e){
      throw CustomeException(e);
    }
  }

  Future<List<Driver>> getAssociateVehicle()async{
    try{
      final response = await _dio.get(
          GET_ASSOCIATE_VEHICLE_URL,
        options: Options(
            headers: {
              'requirestoken': true,
            }
        )
      );

      return response.data["data"].map<Driver>((json)=> Driver.vehicleDriverAssociation(json)).toList();
    }catch(e){
      throw  CustomeException(e);
    }
  }
}