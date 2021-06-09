class User {
  String email;
  String firstName;
  String lastName;
  String userName;
  String id;
  bool enabled;
  bool totp;
  bool emailVerified;
  Map<String, dynamic> attrs;

  User(this.email, this.firstName, this.lastName, this.userName, this.id,
      this.enabled, this.totp, this.emailVerified, this.attrs);

  User.fromJson(Map<String,dynamic> json){
    email = json["email"];
    firstName = json["firstName"];
    lastName = json["lastName"];
    userName = json["username"];
    id = json["id"];
    totp = json["totp"];
    emailVerified = json["emailVerified"];
    attrs = json["attributes"];
    enabled = json["enabled"];
  }
}
