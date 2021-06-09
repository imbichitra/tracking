import 'package:mcs_tracking/Models/token.dart';
import 'package:mcs_tracking/api/auth/api_auth_provider.dart';
import 'package:mcs_tracking/api/dio/dio_client.dart';

class ApiAuthRepository{
  final ApiAuthProvider _apiAuthProvider = ApiAuthProvider(DioClient.getInstance());

  Future<Token> loginUser(user)=>_apiAuthProvider.loginUser(user);

  Future<Token> getAccessToken(refreshToken)=>_apiAuthProvider.getAccessToken(refreshToken);
}