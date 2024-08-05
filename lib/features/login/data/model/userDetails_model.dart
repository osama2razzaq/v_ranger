// To parse this JSON data, do
//
//     final userDetails = userDetailsFromJson(jsonString);

import 'dart:convert';

UserDetails userDetailsFromJson(String str) =>
    UserDetails.fromJson(json.decode(str));

String userDetailsToJson(UserDetails data) => json.encode(data.toJson());

class UserDetails {
  String? accessToken;
  String? tokenType;
  Details? details;

  UserDetails({
    this.accessToken,
    this.tokenType,
    this.details,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        details:
            json["details"] == null ? null : Details.fromJson(json["details"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "details": details?.toJson(),
      };
}

class Details {
  int? id;
  String? username;
  String? name;
  String? phoneNumber;
  List<String>? permissions;
  String? icNumber;
  int? appLogin;
  String? sensitive;
  dynamic supervisor;
  int? status;
  int? companyId;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? latitude;
  String? longitude;
  String? devicetoken;

  Details({
    this.id,
    this.username,
    this.name,
    this.phoneNumber,
    this.permissions,
    this.icNumber,
    this.appLogin,
    this.sensitive,
    this.supervisor,
    this.status,
    this.companyId,
    this.createdAt,
    this.updatedAt,
    this.latitude,
    this.longitude,
    this.devicetoken,
  });

  factory Details.fromJson(Map<String, dynamic> json) => Details(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        permissions: json["permissions"] == null
            ? []
            : List<String>.from(json["permissions"]!.map((x) => x)),
        icNumber: json["ic_number"],
        appLogin: json["app_login"],
        sensitive: json["sensitive"],
        supervisor: json["supervisor"],
        status: json["status"],
        companyId: json["company_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        latitude: json["latitude"],
        longitude: json["longitude"],
        devicetoken: json["devicetoken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "phone_number": phoneNumber,
        "permissions": permissions == null
            ? []
            : List<dynamic>.from(permissions!.map((x) => x)),
        "ic_number": icNumber,
        "app_login": appLogin,
        "sensitive": sensitive,
        "supervisor": supervisor,
        "status": status,
        "company_id": companyId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "latitude": latitude,
        "longitude": longitude,
        "devicetoken": devicetoken,
      };
}
