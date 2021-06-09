import 'package:dio/dio.dart';
import 'package:mcs_tracking/api/constant.dart';
import 'package:mcs_tracking/api/exception/custome_exception.dart';
import 'package:mcs_tracking/Models/currentUser.dart';


class CurrentUserProvide{
  Dio _dio;

  CurrentUserProvide(Dio dio){
    _dio = dio;
  }

  Future<CurrentUser> getCurrentUser()async{
    try{
      final response = await _dio.get(
        CURRENT_USER_URL,
        options: Options(
          headers: {
            'requirestoken': true,
          },
        ),
      );
      return CurrentUser.fromJson(response.data);
    }catch(e){
      print(e);
      throw CustomeException(e);
    }
  }
}