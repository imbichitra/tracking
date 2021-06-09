import 'package:mcs_tracking/Models/driver/driver.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';
import 'package:mcs_tracking/api/driver/driver_provider.dart';

class DriverRepository{
  final DriverProvider _apiDriverProvider = DriverProvider(DioClient.getInstance());

  Future<int> createDriver(driver)=>_apiDriverProvider.createDriver(driver);

  Future<int> updateDriver(driver)=>_apiDriverProvider.updateDriver(driver);

  Future<List<Driver>> getAllDriver()=>_apiDriverProvider.getAllDriver();

  Future<int> deleteDriver(int driverId) => _apiDriverProvider.deleteDriver(driverId);

  Future<int> associateDriverWithVehicle(vehicleId, deiverId)=>_apiDriverProvider.associateDriverWithVehicle(vehicleId, deiverId);

  Future<List<Driver>> getAssociateVehicle() => _apiDriverProvider.getAssociateVehicle();
  
}