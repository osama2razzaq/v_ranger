// To parse this JSON data, do
//
//     final batchDetailsList = batchDetailsListFromJson(jsonString);

import 'dart:convert';

BatchDetailsList batchDetailsListFromJson(String str) =>
    BatchDetailsList.fromJson(json.decode(str));

String batchDetailsListToJson(BatchDetailsList data) =>
    json.encode(data.toJson());

class BatchDetailsList {
  String? status;
  String? message;
  Data? data;

  BatchDetailsList({
    this.status,
    this.message,
    this.data,
  });

  factory BatchDetailsList.fromJson(Map<String, dynamic> json) =>
      BatchDetailsList(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class Data {
  int? pendingCount;
  int? completedCount;
  int? abortedCount;
  List<PendingDetail>? pendingDetails;
  List<dynamic>? completedDetails;
  List<dynamic>? abortedDetails;

  Data({
    this.pendingCount,
    this.completedCount,
    this.abortedCount,
    this.pendingDetails,
    this.completedDetails,
    this.abortedDetails,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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
  String? name;
  String? icNo;
  String? accountNo;
  String? billNo;
  String? amount;
  String? address;
  String? districtLa;
  String? tamanMmid;
  int? assignedto;
  String? batchfileLatitude;
  String? status;
  String? batchfileLongitude;
  dynamic pinnedAt;

  PendingDetail({
    this.id,
    this.batchId,
    this.name,
    this.icNo,
    this.accountNo,
    this.billNo,
    this.amount,
    this.address,
    this.districtLa,
    this.tamanMmid,
    this.assignedto,
    this.batchfileLatitude,
    this.status,
    this.batchfileLongitude,
    this.pinnedAt,
  });

  factory PendingDetail.fromJson(Map<String, dynamic> json) => PendingDetail(
        id: json["id"],
        batchId: json["batch_id"],
        name: json["name"],
        icNo: json["ic_no"],
        accountNo: json["account_no"],
        billNo: json["bill_no"],
        amount: json["amount"],
        address: json["address"],
        districtLa: json["district_la"],
        tamanMmid: json["taman_mmid"],
        assignedto: json["assignedto"],
        batchfileLatitude: json["batchfile_latitude"],
        status: json["status"],
        batchfileLongitude: json["batchfile_longitude"],
        pinnedAt: json["pinned_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "batch_id": batchId,
        "name": name,
        "ic_no": icNo,
        "account_no": accountNo,
        "bill_no": billNo,
        "amount": amount,
        "address": address,
        "district_la": districtLa,
        "taman_mmid": tamanMmid,
        "assignedto": assignedto,
        "batchfile_latitude": batchfileLatitude,
        "status": status,
        "batchfile_longitude": batchfileLongitude,
        "pinned_at": pinnedAt,
      };
}
