
import 'package:mcs_tracking/Models/graph/fleetDistanceVehicleAverage.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';
import 'package:mcs_tracking/api/graph/vehicle_distance_average_provide.dart';

class VehicleDistanceAverageRepository{
  final VehicleDistanceAverageProvide vehicleDistanceAverageProvide = VehicleDistanceAverageProvide(DioClient.getInstance());
  Future<DistanceVehicleList> getDistanceVehicleAverage(data)=> vehicleDistanceAverageProvide.fetchVehicleDistance(data);

}