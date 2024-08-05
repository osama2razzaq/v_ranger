// To parse this JSON data, do
//
//     final batches = batchesFromJson(jsonString);

import 'dart:convert';

BatchesModel batchesFromJson(String str) =>
    BatchesModel.fromJson(json.decode(str));

String batchesToJson(BatchesModel data) => json.encode(data.toJson());

class BatchesModel {
  String? status;
  String? message;
  List<Datum>? data;

  BatchesModel({
    this.status,
    this.message,
    this.data,
  });

  factory BatchesModel.fromJson(Map<String, dynamic> json) => BatchesModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? batchId;
  String? batchNo;
  int? pendingCount;
  int? completedCount;
  int? abortedCount;
  List<PendingDetail>? pendingDetails;
  List<dynamic>? completedDetails;
  List<dynamic>? abortedDetails;

  Datum({
    this.batchId,
    this.batchNo,
    this.pendingCount,
    this.completedCount,
    this.abortedCount,
    this.pendingDetails,
    this.completedDetails,
    this.abortedDetails,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        batchId: json["batch_id"],
        batchNo: json["batch_no"],
        pendingCount: json["pending_count"],
        completedCount: json["completed_count"],
        abortedCount: json["aborted_count"],
        pendingDetails: json["pending_details"] == null
            ? []
            : List<PendingDetail>.from(
                json["pending_details"]!.map((x) => PendingDetail.fromJson(x))),
        completedDetails: json["completed_details"] == null
            ? []
            : List<dynamic>.from(json["completed_details"]!.map((x) => x)),
        abortedDetails: json["aborted_details"] == null
            ? []
            : List<dynamic>.from(json["aborted_details"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "batch_id": batchId,
        "batch_no": batchNo,
        "pending_count": pendingCount,
        "completed_count": completedCount,
        "aborted_count": abortedCount,
        "pending_details": pendingDetails == null
            ? []
            : List<dynamic>.from(pendingDetails!.map((x) => x.toJson())),
        "completed_details": completedDetails == null
            ? []
            : List<dynamic>.from(completedDetails!.map((x) => x)),
        "aborted_details": abortedDetails == null
            ? []
            : List<dynamic>.from(abortedDetails!.map((x) => x)),
      };
}

class PendingDetail {
  int? id;
  int? batchId;
  String? address;
  String? districtLa;
  String? tamanMmid;
  int? assignedto;
  String? batchfileLatitude;
  String? status;
  String? batchfileLongitude;

  PendingDetail({
    this.id,
    this.batchId,
    this.address,
    this.districtLa,
    this.tamanMmid,
    this.assignedto,
    this.batchfileLatitude,
    this.status,
    this.batchfileLongitude,
  });

  factory PendingDetail.fromJson(Map<String, dynamic> json) => PendingDetail(
        id: json["id"],
        batchId: json["batch_id"],
        address: json["address"],
        districtLa: json["district_la"],
        tamanMmid: json["taman_mmid"],
        assignedto: json["assignedto"],
        batchfileLatitude: json["batchfile_latitude"],
        status: json["status"],
        batchfileLongitude: json["batchfile_longitude"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "batch_id": batchId,
        "address": address,
        "district_la": districtLa,
        "taman_mmid": tamanMmid,
        "assignedto": assignedto,
        "batchfile_latitude": batchfileLatitude,
        "status": status,
        "batchfile_longitude": batchfileLongitude,
      };
}
