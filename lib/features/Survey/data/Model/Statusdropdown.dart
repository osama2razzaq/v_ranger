// To parse this JSON data, do
//
//     final statusdropdown = statusdropdownFromJson(jsonString);

import 'dart:convert';

Statusdropdown statusdropdownFromJson(String str) =>
    Statusdropdown.fromJson(json.decode(str));

String statusdropdownToJson(Statusdropdown data) => json.encode(data.toJson());

class Statusdropdown {
  String? status;
  List<Drcode>? drcode;

  Statusdropdown({
    this.status,
    this.drcode,
  });

  factory Statusdropdown.fromJson(Map<String, dynamic> json) => Statusdropdown(
        status: json["status"],
        drcode: json["drcode"] == null
            ? []
            : List<Drcode>.from(json["drcode"]!.map((x) => Drcode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "drcode": drcode == null
            ? []
            : List<dynamic>.from(drcode!.map((x) => x.toJson())),
      };
}

class Drcode {
  int? id;
  String? statuscode;
  String? description;
  int? companyId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Drcode({
    this.id,
    this.statuscode,
    this.description,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  });

  factory Drcode.fromJson(Map<String, dynamic> json) => Drcode(
        id: json["id"],
        statuscode: json["statuscode"],
        description: json["description"],
        companyId: json["company_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "statuscode": statuscode,
        "description": description,
        "company_id": companyId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
