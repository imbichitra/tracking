class Organization {
  int orgId;
  String orgRefName;
  String orgName;
  String description;
  String address;
  bool status;
  String imageUrl;
  String firstName;
  String lastName;
  String contactEmail;
  String contactNumber;

  int paramId;
  double overSpeedLimit;
  double underSpeedLimit;
  double fuelLimit;
  double underUtilizedHours;
  double overUtilizedHours;
  double underUtlizedKms;
  double overUtilizedkms;

  Organization(
      {this.orgId,
      this.orgRefName,
      this.orgName,
      this.description,
      this.address,
      this.status,
      this.imageUrl,
      this.firstName,
      this.lastName,
      this.contactEmail,
      this.contactNumber});

  Organization.fromJson(Map<String, dynamic> json) {
    print("working---------------------here 1");
    print(json);
    print(json["status"]);
    orgId = json['orgId'];
    orgRefName = json['orgRefName'];
    orgName = json['orgName'];
    description = json['description'];
    address = json['address'];
    status = json['status'];
    imageUrl = json['imageUrl'] != null?json['imageUrl']:null;
    firstName = json['firstName'] !=null?json['firstName']:null;
    lastName = json['lastName'] !=null?json['lastName']:null;
    contactEmail = json['contactEmail'] !=null?json['contactEmail']:null;
    contactNumber = json['contactNumber'] !=null?json['contactNumber']:null;


  }

  Organization.myOrganization(Map<String,dynamic> json){
    this.orgId = json["orgId"];
    this.orgRefName = json["orgRefName"];
    this.orgName = json["orgName"];
    this.description = json["description"];
    this.status = json["status"];
    this.paramId = json["params"]["paramId"];
    this.overSpeedLimit = json["params"]["overSpeedLimit"].toDouble();
    this.underSpeedLimit = json["params"]["underSpeedLimit"].toDouble();
    this.fuelLimit = json["params"]["fuelLimit"].toDouble();
    this.underUtilizedHours = json["params"]["underUtilizedHours"].toDouble();
    this.overUtilizedHours = json["params"]["overUtilizedHours"].toDouble();
    this.overUtilizedkms = json["params"]["overUtilizedKms"].toDouble();
    this.underUtlizedKms = json["params"]["underUtilizedKms"].toDouble();

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.orgId != null){
      data['orgId'] = this.orgId;
    }
    data['orgRefName'] = this.orgRefName;
    data['orgName'] = this.orgName;
    data['description'] = this.description;
    if(this.address != null){
      data['address'] = this.address;
    }
    if(this.status != null){
      data['status'] = this.status;
    }
    if(this.imageUrl != null){
      data['imageUrl'] = this.imageUrl;
    }
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['contactEmail'] = this.contactEmail;
    data['contactNumber'] = this.contactNumber;
    return data;
  }
}