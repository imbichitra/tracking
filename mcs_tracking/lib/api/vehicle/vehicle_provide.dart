import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/vehicle/vehicle.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';

class VehicleProvider {
  Dio _dio;

  VehicleProvider(Dio dio) {
    _dio = dio;
  }

  Future<int> createVehicle(vehicle) async {
    try {
      final response = await _dio.post(
        CREATE_VEHICLE_URL,
        data: vehicle,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      return response.statusCode; //201
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<int> deleteVehicle(int vehicleId) async {
    try {
      final response = await _dio.delete(
        DELTE_VEHICLE_URL + vehicleId.toString(),
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      return response.statusCode; //200
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<List<Vehicle>> getAllVehicle() async {
    try {
      final response = await _dio.get(
        GET_VEHICLE_URL,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      print(response.data);
      return response.data["data"]
          .map<Vehicle>((json) => Vehicle.fromJson(json))
          .toList();
    } catch (e) {
      print("Exception-------------->");
      throw CustomeException(e);
    }
  }

  Future<List<Vehicle>> getAllVehiclInfo() async {
    try {
      final response = await _dio.get(
        GET_VEHICLE_INFO_URL,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      return response.data["data"]
          .map<Vehicle>((json) => Vehicle.fromJson(json))
          .toList();
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<int> updateVehicl(vehicle) async {
    try {
//      print("working");
      final response = await _dio.put(
        UPDATE_VEHICLE_URL,
        data: vehicle,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      print(response.data);
      return response.statusCode;
    } catch (e) {
      throw CustomeException(e);
    }
  }

  // Future<List<Vehicle>> getAssociateVehicle() async {
  //   try {
  //     final response = await _dio.get(
  //       GET_ASSOCIATE_DRIVER_URL,
  //       options: Options(
  //         headers: {
  //           'requirestoken': true,
  //         },
  //       ),
  //     );
  //     return response.data
  //         .map<Vehicle>((json) => Vehicle.fromJsonVehicleAssociation(json))
  //         .toList();
  //   } catch (e) {
  //     throw CustomeException(e);
  //   }
  // }

  Future<int> associateVehicleWithDriver(object) async {
    try {
      final respond = await _dio.post(
        CREATE_ASSOCIATE_DRIVER_VEHICLE_URL,
        data: object,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );

      return respond.statusCode;
    } catch (e) {
      throw CustomeException(e);
    }
  }

  // Future<List<Vehicle>> getAssociateDeviceAndVehicle() async {
  //   try {
  //     final response = await _dio.get(
  //       GET_ASSOCIATE_VEHICLE_URL,
  //       options: Options(
  //         headers: {
  //           'requirestoken': true,
  //         },
  //       ),
  //     );
  //     return response.data
  //         .map<Vehicle>((json) => Vehicle.fromDeviceAssociation(json))
  //         .toList();
  //   } catch (e) {
  //     throw CustomeException(e);
  //   }
  // }

  Future<int> associateVehicleWithDevice(object) async {
    try {
      final response = await _dio.post(CREATE_ASSOCIATE_DEVICE_VEHICLE_URL,
          data: object,
          options: Options(headers: {
            'requirestoken': true,
          }));
      print(response.data);
      return response.statusCode;
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<OwnerDetails> getOwnerDetails(vehicleId)async{
    try{
      final response = await _dio.get(
          GET_OWNER_URL+vehicleId.toString(),
        options: Options(
          headers: {
            'requirestoken': true,
          }
        )
      );
      return OwnerDetails.fromJson(response.data);
    }catch(e){
      throw CustomeException(e);
    }
  }
}
