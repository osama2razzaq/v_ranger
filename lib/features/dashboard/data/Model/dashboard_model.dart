// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

DashboardModel dashboardModelFromJson(String str) =>
    DashboardModel.fromJson(json.decode(str));

String welcomeToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  int? totalBatches;
  int? totalBatchDetails;
  int? totalCompletedBatchDetails;
  List<Batch>? batches;

  DashboardModel({
    this.totalBatches,
    this.totalBatchDetails,
    this.totalCompletedBatchDetails,
    this.batches,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        totalBatches: json["total_batches"],
        totalBatchDetails: json["total_batch_details"],
        totalCompletedBatchDetails: json["total_completed_batch_details"],
        batches: json["batches"] == null
            ? []
            : List<Batch>.from(json["batches"]!.map((x) => Batch.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_batches": totalBatches,
        "total_batch_details": totalBatchDetails,
        "total_completed_batch_details": totalCompletedBatchDetails,
        "batches": batches == null
            ? []
            : List<dynamic>.from(batches!.map((x) => x.toJson())),
      };
}

class Batch {
  int? id;
  String? batchNo;
  List<BatchDetail>? batchDetails;

  Batch({
    this.id,
    this.batchNo,
    this.batchDetails,
  });

  factory Batch.fromJson(Map<String, dynamic> json) => Batch(
        id: json["id"],
        batchNo: json["batch_no"],
        batchDetails: json["batch_details"] == null
            ? []
            : List<BatchDetail>.from(
                json["batch_details"]!.map((x) => BatchDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "batch_no": batchNo,
        "batch_details": batchDetails == null
            ? []
            : List<dynamic>.from(batchDetails!.map((x) => x.toJson())),
      };
}

class BatchDetail {
  int? id;
  int? batchId;
  String? address;
  String? districtLa;
  String? tamanMmid;
  int? assignedto;
  String? batchfileLatitude;
  String? batchfileLongitude;

  BatchDetail({
    this.id,
    this.batchId,
    this.address,
    this.districtLa,
    this.tamanMmid,
    this.assignedto,
    this.batchfileLatitude,
    this.batchfileLongitude,
  });

  factory BatchDetail.fromJson(Map<String, dynamic> json) => BatchDetail(
        id: json["id"],
        batchId: json["batch_id"],
        address: json["address"],
        districtLa: json["district_la"],
        tamanMmid: json["taman_mmid"],
        assignedto: json["assignedto"],
        batchfileLatitude: json["batchfile_latitude"],
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
        "batchfile_longitude": batchfileLongitude,
      };
}
