import 'package:flutter/material.dart';
import 'package:mcs_tracking/Models/token.dart';
import 'package:mcs_tracking/api/auth/api_auth_repository.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/injector/injector.dart';
import 'package:mcs_tracking/storage/sharedpreferences/shared_preferences_manager.dart';

class AuthState extends ChangeNotifier{
  bool _isLoading = false;
  bool _isError = false;

  String _errorMessage;
  Token token;
  ApiAuthRepository apiAuthRepository = ApiAuthRepository();
  final SharedPreferencesManager _sharedPreferencesManager = locator<SharedPreferencesManager>();

  bool get isLoadin => _isLoading;
  bool get isError => _isError;
  String get errorMessage => _errorMessage;
  Token get getToken => token;
  AuthState(){
    //get all initial call like whatever u call in initState
  }

  Future<void> loginUser(user) async {
    print("hi");
    try{
      _isLoading = true; 
      notifyListeners();
      print(_isLoading);
      token = await apiAuthRepository.loginUser(user);
      String newAccessToken = token.token;
      String newRefreshToken = token.refreshtoken;
      print(newAccessToken);
      await _sharedPreferencesManager.putString(SharedPreferencesManager.keyAccessToken, newAccessToken);
      await _sharedPreferencesManager.putString(SharedPreferencesManager.keyRefreshToken, newRefreshToken);
      print(_isLoading);
      _isLoading = false;
      _isError = false;
      notifyListeners();
      print("kkk");
    }catch(e){
      _isError = true;
      _isLoading = false;
      
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

}