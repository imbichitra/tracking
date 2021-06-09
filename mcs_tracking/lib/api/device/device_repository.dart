import 'package:mcs_tracking/Models/device/device.dart';
import 'package:mcs_tracking/api/device/device_provide.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';

class DeviceRepository{
  final DeviceProvider _apiDeviceProvider = DeviceProvider(DioClient.getInstance());

  Future<int> createDevice(device)=>_apiDeviceProvider.createDevice(device);

  Future<List<Device>> getAllDevice()=>_apiDeviceProvider.getAllDevice();

  Future<List<Device>> getAllDeviceInfo(device)=>_apiDeviceProvider.getAllDeviceInfo();

  Future<int> deleteDevice(deviceId)=>_apiDeviceProvider.deleteDevice(deviceId);

  Future<int> updateDevice(device)=>_apiDeviceProvider.updateDevice(device);

  Future<int> associateDeviceWithVehicle(data)=>_apiDeviceProvider.associateDeviceWithVehicle(data);

  Future<List<Device>> getAssociateDeviceVehicle() => _apiDeviceProvider.getAssociateDeviceVehicle();

}