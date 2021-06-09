
import 'package:mcs_tracking/api/user/user_provide.dart';
import 'package:mcs_tracking/Models/user/user.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';

class UserRepository{
  final UserProvide userProvide = UserProvide(DioClient.getInstance());
  Future<List<User>> getUsers() => userProvide.getUsers();
  Future<User> postUser(data)=> userProvide.postUser(data);
}