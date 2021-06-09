import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/graph/routeReplay.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/api/graph/routeReplay_repository.dart';
class RouteReplayStateManagement extends ChangeNotifier {
  RouteReplay routeReplay;
  bool isLoading = false;

  RouteReplayRepository routeReplayRepository = RouteReplayRepository();


  RouteReplay get getRouteReplayData => this.routeReplay;

  void setRouteReplayData(RouteReplay data){
    this.routeReplay = data;
    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchRouteReplayData(postData)async{
    try{
      RouteReplay data = await routeReplayRepository.getRouteReplayData(postData);
      setRouteReplayData(data);

    }catch(e){
      throw CustomeException(e);
    }
  }
}