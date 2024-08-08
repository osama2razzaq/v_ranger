// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  String? status;
  Profile? profile;

  ProfileModel({
    this.status,
    this.profile,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "profile": profile?.toJson(),
      };
}

class Profile {
  int? id;
  String? username;
  String? name;
  String? phoneNumber;
  String? icNumber;
  String? sensitive;

  Profile({
    this.id,
    this.username,
    this.name,
    this.phoneNumber,
    this.icNumber,
    this.sensitive,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["id"],
        username: json["username"],
        name: json["name"],
        phoneNumber: json["phone_number"],
        icNumber: json["ic_number"],
        sensitive: json["sensitive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "name": name,
        "phone_number": phoneNumber,
        "ic_number": icNumber,
        "sensitive": sensitive,
      };
}
