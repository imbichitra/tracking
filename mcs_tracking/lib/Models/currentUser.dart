class CurrentUser {
  String uuid;
  String emailid;
  String givenName;
  String orgRefName;

  String get getorgRefName => this.orgRefName;

  CurrentUser({this.uuid, this.emailid, this.givenName, this.orgRefName});

  CurrentUser.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    emailid = json['emailid'];
    givenName = json['given_name'];
    orgRefName = json['orgRefName'];
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['emailid'] = this.emailid;
    data['given_name'] = this.givenName;
    data['orgRefName'] = this.orgRefName;
    return data;
  }
}


class CurrentUserSingleton{
  CurrentUser _currentUser;
  static final CurrentUserSingleton _inst = CurrentUserSingleton._internal();


  static CurrentUserSingleton get getInstance => _inst;

  factory CurrentUserSingleton(CurrentUser currentUser){
    _inst._currentUser = currentUser;
    return _inst;
  }

  CurrentUser get getCurrentUser => _currentUser;


  CurrentUserSingleton._internal();

}