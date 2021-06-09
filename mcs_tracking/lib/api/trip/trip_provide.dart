import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/trip/trip.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';

class TripProvide {
  Dio _dio;

  TripProvide(this._dio);

  Future<Trip> createTrip(data) async {
    try {
      final response = await _dio.post(
          CREATE_TRIP,
          data: data,
          options: Options(
              headers: {
                'Content-Type': 'application/json',
              }
          )
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("inside status code 200");
        Trip trip = Trip.fromJson(response.data);
        return trip;
      }else{
        print("############################### inside else block");
        print(response.data);
      }
    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<List<Trip>> getTrip(String orgRefName) async {
    try {
      final response = await _dio.get(
          GET_TRIP + orgRefName,
          options: Options(
              headers: {
                'requirestoken': true,
              }
          )
      );

      return response.data.map<Trip>((element)=> Trip.getTrip(element)).toList();

    } catch (e) {
      throw CustomeException(e);
    }
  }

  Future<Trip> startTrip(String orgRefName,String tripId) async{
      try{
        final response = await _dio.post(
            START_TRIP+orgRefName+"&tripId="+tripId,
          options:Options(
            headers: {
              'Content-Type': 'application/json',
            }
          )
        );
        Trip trip = Trip.startTrip(response.data);
        return trip;
      }catch(e){
        throw CustomeException(e);
      }
  }

  Future<Trip> endTrip(orgRefName,tripId, vehicleId) async{
    try{
      final response = await _dio.patch(
        END_TRIP+orgRefName+"&vehicleId="+vehicleId.toString()+"&tripId="+tripId,
        options:Options(
            headers: {
              'Content-Type': 'application/json',
            }
          )
      );

      Trip trip = Trip.endTrip(response.data);
      return trip;

    }catch(e){
      throw CustomeException(e);
    }
  }

  Future<Trip> updateTrip(data) async{
    try {
      final response = await _dio.put(
          UPDATE_TRIP,
          data: data,
          options: Options(
              headers: {
                'Content-Type': 'application/json',
              }
          )
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("inside status code 200");
        Trip trip = Trip.updateTrip(response.data);
        return trip;
      }else{
        print(response.data);
      }
    } catch (e) {
      throw CustomeException(e);
    }
  }


}