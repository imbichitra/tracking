import 'package:dio/dio.dart';
import 'package:mcs_tracking/Models/token.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';

class ApiAuthProvider{
  Dio _dio;
  ApiAuthProvider(Dio dio){
    _dio = dio;
//    _dio.interceptors.clear();
  }

  Future<Token> loginUser(var user) async {
    try {
      final response = await _dio.post(
        LOGIN_URL,
        data: user,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      Token t =Token.fromJson(response.data);
      return t;
    } catch (error) {
      throw CustomeException(error);
    }
  }

  Future<Token> getAccessToken(String refreshToken) async {
    try{
     final response = await _dio.get(
        '$GET_ACCESS_TOKEN$refreshToken',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      Token t =Token.fromJson(response.data);
      return t;
    }catch(e){
      throw CustomeException(e);
    }
  }
}