// To parse this JSON data, do
//
//     final leaderBoardDetails = leaderBoardDetailsFromJson(jsonString);

import 'dart:convert';

LeaderBoardDetails leaderBoardDetailsFromJson(String str) =>
    LeaderBoardDetails.fromJson(json.decode(str));

String leaderBoardDetailsToJson(LeaderBoardDetails data) =>
    json.encode(data.toJson());

class LeaderBoardDetails {
  String? status;
  RequestedDriver? requestedDriver;
  List<OtherDriver>? otherDrivers;

  LeaderBoardDetails({
    this.status,
    this.requestedDriver,
    this.otherDrivers,
  });

  factory LeaderBoardDetails.fromJson(Map<String, dynamic> json) =>
      LeaderBoardDetails(
        status: json["status"],
        requestedDriver: json["requested_driver"] == null
            ? null
            : RequestedDriver.fromJson(json["requested_driver"]),
        otherDrivers: json["other_drivers"] == null
            ? []
            : List<OtherDriver>.from(
                json["other_drivers"]!.map((x) => OtherDriver.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "requested_driver": requestedDriver?.toJson(),
        "other_drivers": otherDrivers == null
            ? []
            : List<dynamic>.from(otherDrivers!.map((x) => x.toJson())),
      };
}

class OtherDriver {
  String? driverId;
  String? driverName;
  StatusCounts? statusCounts;

  OtherDriver({
    this.driverId,
    this.driverName,
    this.statusCounts,
  });

  factory OtherDriver.fromJson(Map<String, dynamic> json) => OtherDriver(
        driverId: json["driver_id"],
        driverName: json["driver_name"],
        statusCounts: json["status_counts"] == null
            ? null
            : StatusCounts.fromJson(json["status_counts"]),
      );

  Map<String, dynamic> toJson() => {
        "driver_id": driverId,
        "driver_name": driverName,
        "status_counts": statusCounts?.toJson(),
      };
}

class StatusCounts {
  String? pending;
  String? assigned;
  String? completed;

  StatusCounts({
    this.pending,
    this.assigned,
    this.completed,
  });

  factory StatusCounts.fromJson(Map<String, dynamic> json) => StatusCounts(
        pending: json["pending"],
        assigned: json["assigned"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "pending": pending,
        "assigned": assigned,
        "completed": completed,
      };
}

class RequestedDriver {
  String? driverId;
  String? driverName;
  StatusCounts? statusCounts;

  RequestedDriver({
    this.driverId,
    this.driverName,
    this.statusCounts,
  });

  factory RequestedDriver.fromJson(Map<String, dynamic> json) =>
      RequestedDriver(
        driverId: json["driver_id"],
        driverName: json["driver_name"],
        statusCounts: json["status_counts"] == null
            ? null
            : StatusCounts.fromJson(json["status_counts"]),
      );

  Map<String, dynamic> toJson() => {
        "driver_id": driverId,
        "driver_name": driverName,
        "status_counts": statusCounts?.toJson(),
      };
}
