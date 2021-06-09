import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/trip/trip.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/api/trip/trip_repository.dart';

class TripStateManagement extends ChangeNotifier{

  TripRepository _tripRepository = TripRepository();
  Trip _trip,_createTripResponse;

  List<Trip> _tripList;

  bool _isError = false;
  String _errorMessage;

  String message;




  void setTrip(Trip trip){
    _trip = trip;
    notifyListeners();
  }

  void setCreateStartTripResponse(Trip trip){
    _createTripResponse = trip;
    notifyListeners();
  }

  void setAllTrip(List<Trip> list){
    _tripList = list;
    notifyListeners();
  }


  void setStartTrip(Trip trip){
    _trip = trip;
    notifyListeners();
  }

  void setEndTrip(Trip trip){
    _trip = trip;
    notifyListeners();
  }

  void setUpdateTrip(Trip trip){
    _trip = trip;
    notifyListeners();
  }


  Trip get getTrip => _trip;
  String get getMessage => message;

  bool get isError => _isError;

  List<Trip> get getAllTrip => _tripList;

  Trip get getCreateTripResponse => _createTripResponse;




  Future<void> createTrip(data)async{
    try{
      Trip trip = await _tripRepository.createTrip(data);
      setCreateStartTripResponse(trip);
      notifyListeners();

    }catch(e){
      print("Inside the catch block");
      _isError = true;
      if(e is CustomeException){
        CustomeException ex = e;
        _errorMessage = ex.message;
      }else{
        _errorMessage = e.toString();
      }
      print(_errorMessage);
      notifyListeners();
    }
  }


  Future<void> fetchAllTrip(String orgRefName)async{
    try{
      List<Trip> list = await _tripRepository.getTrip(orgRefName);
      setAllTrip(list);
    }catch(e){
      throw CustomeException(e);
    }
  }

  Future<void> startTrip(String orgRefName, String tripId)async{
    try{
      Trip trip = await _tripRepository.startTrip(orgRefName, tripId);
      setTrip(trip);
    }catch(e){
      throw CustomeException(e);
    }
  }

  Future<void> endTrip(orgRefName,tripId,vehicleId) async{
    try{
      Trip trip = await _tripRepository.endTrip(orgRefName,tripId,vehicleId);
      setEndTrip(trip);
    }catch(e){
      throw(e);
    }
  }

  Future<void> updateTrip(data) async{
    try{
      Trip trip = await _tripRepository.updateTrip(data);
      setUpdateTrip(trip);
    }catch(e){
      throw(e);
    }
  }
}