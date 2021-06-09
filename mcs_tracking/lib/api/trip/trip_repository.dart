

import 'package:mcs_tracking/Models/trip/trip.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';
import 'package:mcs_tracking/api/trip/trip_provide.dart';

class TripRepository{
  final TripProvide _tripProvide = TripProvide(DioClient.getInstance());
  Future<Trip> createTrip(data) => _tripProvide.createTrip(data);
  Future<List<Trip>> getTrip(String orgRefName) => _tripProvide.getTrip(orgRefName);
  Future<Trip> startTrip(String orgRefName,String tripId) => _tripProvide.startTrip(orgRefName, tripId);
  Future<Trip> endTrip(orgRefName,tripId, vehicleId) => _tripProvide.endTrip(orgRefName,tripId, vehicleId);
  Future<Trip> updateTrip(data) => _tripProvide.updateTrip(data);
}