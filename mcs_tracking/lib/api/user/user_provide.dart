import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/Models/user/user.dart';

class UserProvide{
  Dio _dio;

  UserProvide(this._dio);
  Future<List<User>> getUsers() async{
    try{
      final response = await _dio.get(
          GET_USERS,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        )
      );

      return response.data.map<User>((data)=> User.fromJson(data)).toList();
    }catch(e){
      throw CustomeException(e);
    }
  }

  Future<User> postUser(var data)async{
    try{
      final response = await _dio.post(
        "",
        data: data,
        options: Options(
          headers: {
            'requirestoken': true,
          }
        )
      );
      final user = User.fromJson(response.data);
      return user;
    }catch(e){
      throw CustomeException(e);
    }
  }
}