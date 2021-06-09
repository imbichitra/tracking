class LoginModel {
  String accessToken;
  int expires_in;
  String role;
  String preferredName;
  String refreshToken;
  int refreshTokenExpires;

  LoginModel() {}

  LoginModel.fromJson(Map<String, dynamic> json) {
  
    this.accessToken = json['access_token'];
    this.expires_in = json['expires_in'];
    this.refreshToken = json['refresh_token'];
    this.role = json['role'];
    this.preferredName = json['preferredName'];
  }

  String get getAccessToken => this.accessToken;
  int get getExpiresIn => this.expires_in;
  String get getRefreshToken => this.refreshToken;
  String get getRole => this.role;
  String get getPreferredName => this.preferredName;

  void setAccessTaken(String accessToken) {
    this.accessToken = accessToken;
  }

  void setExpiresIn(int expiresIn) {
    this.expires_in = expiresIn;
  }

  void setRole(String role) {
    this.role = role;
  }

  void setRefreshToken(String refreshToken) {
    this.refreshToken = refreshToken;
  }

  void setPrefferedName(String preffredname) {
    this.preferredName = preffredname;
  }
}
