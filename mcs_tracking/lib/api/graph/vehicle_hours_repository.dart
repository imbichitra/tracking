

import 'package:mcs_tracking/Models/graph/vehiclesHours.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';
import 'package:mcs_tracking/api/graph/vehicle_hours_provide.dart';

class VehicleVsHoursRepository{
  final VehicleHoursProvide _vehicleHoursProvide = VehicleHoursProvide(DioClient.getInstance());
  Future<VehicleHoursList> getVehicleVsHours(data) => _vehicleHoursProvide.fetchVehicleVsHpurs(data);
}