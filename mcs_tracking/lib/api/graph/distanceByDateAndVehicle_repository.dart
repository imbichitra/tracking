import 'package:mcs_tracking/Models/graph/distanceByDateAndVehicle.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';
import 'package:mcs_tracking/api/graph/distanceByDateAndVehicle_provide.dart';

class DistanceByDateAndVehicleRepository{
  final DistanceByDateAndVehicleProvide _distanceByDateAndVehicleProvide = DistanceByDateAndVehicleProvide(DioClient.getInstance());

  Future<DistanceByDateAndVehicle> fetchDistanceByDateAndVehicle(data) => _distanceByDateAndVehicleProvide.getDistanceByDate(data);

}