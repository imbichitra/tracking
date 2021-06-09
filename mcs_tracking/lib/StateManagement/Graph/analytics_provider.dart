import 'package:flutter/cupertino.dart';
import 'package:mcs_tracking/Models/graph/fleetanalytics.dart';
import 'package:mcs_tracking/api/graph/analytics_repository.dart';

class AnalyticsStateManagement extends ChangeNotifier{

  AnalyticsRepository _analyticsRepository = AnalyticsRepository();

  FleetAnalytics _underUtilizedObj;
  FleetAnalytics _overSpeedObj;
  FleetAnalytics _underSpeedObj;
  FleetAnalytics _lowFueldObj;


  void setUnderutilizedVehicles(FleetAnalytics underutilzedVehicles){
    this._underUtilizedObj = underutilzedVehicles;
    notifyListeners();
  }

  void setOverSpeedVehicles(FleetAnalytics overSpeedVehicles){
    this._overSpeedObj = overSpeedVehicles;
    notifyListeners();
  }

  void setUnderSpeedVehicles(FleetAnalytics underSpeedVehicles){
    this._underSpeedObj = underSpeedVehicles;
    notifyListeners();
  }

  void setLowFuelVehicles(FleetAnalytics lowFuelVehicles){
    this._lowFueldObj = lowFuelVehicles;
    notifyListeners();
  }

  FleetAnalytics get getUnderutilizedVehicles => this._underUtilizedObj;
  FleetAnalytics get getOverSpeedVehicles => this._overSpeedObj;
  FleetAnalytics get getUnderSpeedVehicles => this._underSpeedObj;
  FleetAnalytics get getLowFuelVehicles => this._lowFueldObj;

  Future<void> fetchUnderutilizedVehicles(String orgRefName)async{
    try{
      FleetAnalytics underutilisedObject = await _analyticsRepository.getUnderutilised(orgRefName);
      setUnderutilizedVehicles(underutilisedObject);
    }catch(e){
      print(e);
    }
  }


  Future<void> fetchOverSpeedVehicles(String orgRefName)async{
    try{
      FleetAnalytics overSpeedObj = await _analyticsRepository.getOverSpeed(orgRefName);
      setOverSpeedVehicles(overSpeedObj);
    }catch(e){
      print(e);
    }
  }

  Future<void> fetchUnderSpeedVehicles(String orgRefName)async{
    try{
      FleetAnalytics underSpeedObj = await _analyticsRepository.getUnderSpeed(orgRefName);
      setUnderSpeedVehicles(underSpeedObj);
    }catch(e){
      print(e);
    }
  }

  Future<void> fetchLowFuelVehicles(String orgRefName)async{
    try{
      FleetAnalytics lowFuelObj = await _analyticsRepository.getLowFuel(orgRefName);
      setLowFuelVehicles(lowFuelObj);
    }catch(e){
      print(e);
    }
  }







}