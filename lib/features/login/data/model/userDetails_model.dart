class UserDetails {
  String accessToken;
  String tokenType;
  Details details;

  UserDetails({
    required this.accessToken,
    required this.tokenType,
    required this.details,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      details: Details.fromJson(json['details']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'token_type': tokenType,
      'details': details.toJson(),
    };
  }
}

class Details {
  int id;
  String username;
  String name;
  String phoneNumber;
  List<String> permissions;
  String icNumber;
  int appLogin;
  String sensitive;
  dynamic supervisor;
  int status;
  int companyId;
  String createdAt;
  String updatedAt;
  String latitude;
  String longitude;
  String devicetoken;

  Details({
    required this.id,
    required this.username,
    required this.name,
    required this.phoneNumber,
    required this.permissions,
    required this.icNumber,
    required this.appLogin,
    required this.sensitive,
    this.supervisor,
    required this.status,
    required this.companyId,
    required this.createdAt,
    required this.updatedAt,
    required this.latitude,
    required this.longitude,
    required this.devicetoken,
  });

  factory Details.fromJson(Map<String, dynamic> json) {
    return Details(
      id: json['id'],
      username: json['username'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      permissions: List<String>.from(json['permissions']),
      icNumber: json['ic_number'],
      appLogin: json['app_login'],
      sensitive: json['sensitive'],
      supervisor: json['supervisor'],
      status: json['status'],
      companyId: json['company_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      devicetoken: json['devicetoken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'phone_number': phoneNumber,
      'permissions': permissions,
      'ic_number': icNumber,
      'app_login': appLogin,
      'sensitive': sensitive,
      'supervisor': supervisor,
      'status': status,
      'company_id': companyId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'latitude': latitude,
      'longitude': longitude,
      'devicetoken': devicetoken,
    };
  }
}
