import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/device/device.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';

class DeviceProvider {
  Dio _dio;

  DeviceProvider(Dio dio) {
    _dio = dio;
  }

  Future<int> createDevice(device) async {
    try {
      final response = await _dio.post(
        CREATE_DEVICE_URL,
        data: device,
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

  Future<List<Device>> getAllDevice() async {
    try {
      final response = await _dio.get(
        GET_DEVICE_URL,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      return response.data["data"]
          .map<Device>((json) => Device.fromJson(json))
          .toList();
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<List<Device>> getAllDeviceInfo() async {
    try {
      final response = await _dio.get(
        GET_DEVICE_URL,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );

      print(response.data);
      return response.data["data"]
          .map<Device>((json) => Device.fromJson(json))
          .toList();
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<int> deleteDevice(int deviceId) async {
    try {
      final response = await _dio.delete(
        DELETE_DEVICE_URL + deviceId.toString(),
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

  Future<int> updateDevice(device) async {
    try {
      final response = await _dio.put(
        UPDATE_DEVICE_URL,
        data: device,
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

  Future<int> associateDeviceWithVehicle(data) async {
    try {
      final response = await _dio.post(
        CREATE_ASSOCIATE_DEVICE_VEHICLE_URL,
        data: data,
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

  Future<List<Device>> getAssociateDeviceVehicle() async {
    try {
      final response = await _dio.get(
        GET_ASSOCIATE_DEVICE_VEHICLE_URL,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );

      return response.data["data"]
          .map<Device>((json) => Device.deviceVehicleAssociation(json))
          .toList();
    } catch (e) {
      throw CustomeException(e);
    }
  }
}
