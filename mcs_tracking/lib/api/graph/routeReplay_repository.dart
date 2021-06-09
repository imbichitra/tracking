import 'package:mcs_tracking/Models/graph/routeReplay.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';
import 'package:mcs_tracking/api/graph/routeReplay_provide.dart';

class RouteReplayRepository{
  RouteReplayProvide routeReplayProvide = RouteReplayProvide(DioClient.getInstance());

  Future<RouteReplay> getRouteReplayData(data) => routeReplayProvide.getRouteReplayData(data); 

}