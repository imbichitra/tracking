import 'package:jwt_decoder/jwt_decoder.dart';

class Token {
  String token;
  String refreshtoken;
  String role;

  Token() {}

  Token.fromJson(Map<String, dynamic> json) {
    this.token = json['access_token'];
    this.refreshtoken = json['refresh_token'];
    this.role = JwtDecoder.decode(this.token)["realm_access"]["roles"][0].toString();

  }

  String get getToken => this.token;
  String get getRefreshToken => this.refreshtoken;
  String get getRole => this.role;


  void setToken(String token) {
    this.token = token;
  }

  void setRefreshToken(String refreshToken) {
    this.refreshtoken = refreshToken;
  }

  void setRole(String role) {
    this.role = role;
  }
}
