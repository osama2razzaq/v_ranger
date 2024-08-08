// To parse this JSON data, do
//
//     final dropdownModel = dropdownModelFromJson(jsonString);

import 'dart:convert';

DropdownModel dropdownModelFromJson(String str) =>
    DropdownModel.fromJson(json.decode(str));

String dropdownModelToJson(DropdownModel data) => json.encode(data.toJson());

class DropdownModel {
  String? status;
  List<Classification>? classification;
  List<DrCode>? drCode;
  List<NatureOfBussinessCode>? natureOfBussinessCode;
  List<OccupancyStatus>? occupancyStatus;
  List<Ownership>? ownerships;
  List<PropertyType>? propertyType;

  DropdownModel({
    this.status,
    this.classification,
    this.drCode,
    this.natureOfBussinessCode,
    this.occupancyStatus,
    this.ownerships,
    this.propertyType,
  });

  factory DropdownModel.fromJson(Map<String, dynamic> json) => DropdownModel(
        status: json["status"],
        classification: json["classification"] == null
            ? []
            : List<Classification>.from(
                json["classification"]!.map((x) => Classification.fromJson(x))),
        drCode: json["dr_code"] == null
            ? []
            : List<DrCode>.from(
                json["dr_code"]!.map((x) => DrCode.fromJson(x))),
        natureOfBussinessCode: json["nature_of_bussiness_code"] == null
            ? []
            : List<NatureOfBussinessCode>.from(json["nature_of_bussiness_code"]!
                .map((x) => NatureOfBussinessCode.fromJson(x))),
        occupancyStatus: json["occupancy_status"] == null
            ? []
            : List<OccupancyStatus>.from(json["occupancy_status"]!
                .map((x) => OccupancyStatus.fromJson(x))),
        ownerships: json["ownerships"] == null
            ? []
            : List<Ownership>.from(
                json["ownerships"]!.map((x) => Ownership.fromJson(x))),
        propertyType: json["property_type"] == null
            ? []
            : List<PropertyType>.from(
                json["property_type"]!.map((x) => PropertyType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "classification": classification == null
            ? []
            : List<dynamic>.from(classification!.map((x) => x.toJson())),
        "dr_code": drCode == null
            ? []
            : List<dynamic>.from(drCode!.map((x) => x.toJson())),
        "nature_of_bussiness_code": natureOfBussinessCode == null
            ? []
            : List<dynamic>.from(natureOfBussinessCode!.map((x) => x.toJson())),
        "occupancy_status": occupancyStatus == null
            ? []
            : List<dynamic>.from(occupancyStatus!.map((x) => x.toJson())),
        "ownerships": ownerships == null
            ? []
            : List<dynamic>.from(ownerships!.map((x) => x.toJson())),
        "property_type": propertyType == null
            ? []
            : List<dynamic>.from(propertyType!.map((x) => x.toJson())),
      };
}

class Classification {
  int? id;
  String? classificationName;

  Classification({
    this.id,
    this.classificationName,
  });

  factory Classification.fromJson(Map<String, dynamic> json) => Classification(
        id: json["id"],
        classificationName: json["classification_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "classification_name": classificationName,
      };
}

class DrCode {
  int? id;
  String? code;
  String? drCodeName;

  DrCode({
    this.id,
    this.code,
    this.drCodeName,
  });

  factory DrCode.fromJson(Map<String, dynamic> json) => DrCode(
        id: json["id"],
        code: json["code"],
        drCodeName: json["dr_code_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "dr_code_name": drCodeName,
      };
}

class NatureOfBussinessCode {
  int? id;
  String? code;
  String? natureOfBussinessCodeName;

  NatureOfBussinessCode({
    this.id,
    this.code,
    this.natureOfBussinessCodeName,
  });

  factory NatureOfBussinessCode.fromJson(Map<String, dynamic> json) =>
      NatureOfBussinessCode(
        id: json["id"],
        code: json["code"],
        natureOfBussinessCodeName: json["nature_of_bussiness_code_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "nature_of_bussiness_code_name": natureOfBussinessCodeName,
      };
}

class OccupancyStatus {
  int? id;
  String? occupancyStatusName;

  OccupancyStatus({
    this.id,
    this.occupancyStatusName,
  });

  factory OccupancyStatus.fromJson(Map<String, dynamic> json) =>
      OccupancyStatus(
        id: json["id"],
        occupancyStatusName: json["occupancy_status_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "occupancy_status_name": occupancyStatusName,
      };
}

class Ownership {
  int? id;
  String? ownershipname;

  Ownership({
    this.id,
    this.ownershipname,
  });

  factory Ownership.fromJson(Map<String, dynamic> json) => Ownership(
        id: json["id"],
        ownershipname: json["ownershipname"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ownershipname": ownershipname,
      };
}

class PropertyType {
  int? id;
  String? code;
  String? propertyTypeName;

  PropertyType({
    this.id,
    this.code,
    this.propertyTypeName,
  });

  factory PropertyType.fromJson(Map<String, dynamic> json) => PropertyType(
        id: json["id"],
        code: json["code"],
        propertyTypeName: json["property_type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "property_type_name": propertyTypeName,
      };
}
