import 'package:mcs_tracking/Models/currentUser.dart';
import 'package:mcs_tracking/api/current-user/current_user_provide.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';


class CurrentUserRepository{
    final CurrentUserProvide currentUserProvide = CurrentUserProvide(DioClient.getInstance());

    Future<CurrentUser> getCurrentUser() => currentUserProvide.getCurrentUser();
}