import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/graph/routeReplay.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import  'package:mcs_tracking/api/constant.dart';


class RouteReplayProvide{
  Dio _dio;

  RouteReplayProvide(this._dio);

  Future<RouteReplay> getRouteReplayData(data)async{
    try{
      final response = await _dio.post(
        GET_ROUTE_REPLAY,
        data:data,
        options:Options(
          headers:{
            'Content-Type': 'application/json',
          }
        )
      );

      RouteReplay routeReplay = RouteReplay.fromJson(response.data);

      return routeReplay;
    }catch(e){
      throw CustomeException(e);
    }
  }

}