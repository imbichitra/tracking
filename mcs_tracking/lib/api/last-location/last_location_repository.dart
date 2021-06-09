import 'package:mcs_tracking/api/last-location/last_location_provide.dart';
import 'package:mcs_tracking/Models/vehicle_detail.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';

class LastLocationRepository{
  final LastLocationProvide lastLocationProvide = LastLocationProvide(DioClient.getInstance());

  Future<List<VehicleDetail>> getLastLocation(orgRefName)=> lastLocationProvide.getLastocation(orgRefName);

}