import 'package:mcs_tracking/Models/vehicle/vehicle.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';
import 'package:mcs_tracking/api/vehicle/vehicle_provide.dart';

class VehicleRepository{
  final VehicleProvider _apiAuthProvider = VehicleProvider(DioClient.getInstance());

  Future<int> createVehicle(vehicle)=>_apiAuthProvider.createVehicle(vehicle);

  Future<int> deleteVehicle(vehicleId)=>_apiAuthProvider.deleteVehicle(vehicleId);

  Future<List<Vehicle>> getAllVehicle()=>_apiAuthProvider.getAllVehicle();

  Future<List<Vehicle>> getAllVehiclInfo(vehicle)=>_apiAuthProvider.getAllVehiclInfo();

  Future<int> updateVehicl(vehicle)=>_apiAuthProvider.updateVehicl(vehicle);

  Future<OwnerDetails> getOwnerDetails(id) => _apiAuthProvider.getOwnerDetails(id);

  // Future<List<Vehicle>> getVehicleDriverMap() => _apiAuthProvider.getAssociateVehicle();

  Future<int>  associateVehicleWithDriver(object) => _apiAuthProvider.associateVehicleWithDriver(object);

  // Future<List<Vehicle>> getVehicleDeviceMap() => _apiAuthProvider.getAssociateDeviceAndVehicle();

  Future<int>  associateVehicleWithDevice(object) => _apiAuthProvider.associateVehicleWithDevice(object);
}