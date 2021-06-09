import 'package:mcs_tracking/Models/graph/distanceByVehicle.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';
import 'package:mcs_tracking/api/graph/distanceByVehicle_provide.dart';

class DistanceByVehicleRepository{
  final DistanceByVehicleProvide _distanceByVehicleProvide = DistanceByVehicleProvide(DioClient.getInstance());

  Future<DistanceByVehicle> getDistanceByVehicle(data) => _distanceByVehicleProvide.fetchDistanceByVehicle(data);
}