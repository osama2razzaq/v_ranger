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

  BatchDetailsList? copyWith({required data}) {}
}

class Data {
  int? pendingCount;
  int? completedCount;
  int? abortedCount;
  List<PendingDetail>? pendingDetails;
  List<CompletedDetail>? completedDetails;
  List<AbortedDetail>? abortedDetails;

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
            : List<CompletedDetail>.from(json["completed_details"]!
                .map((x) => CompletedDetail.fromJson(x))),
        abortedDetails: json["aborted_details"] == null
            ? []
            : List<AbortedDetail>.from(
                json["aborted_details"]!.map((x) => AbortedDetail.fromJson(x))),
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
            : List<dynamic>.from(completedDetails!.map((x) => x.toJson())),
        "aborted_details": abortedDetails == null
            ? []
            : List<dynamic>.from(abortedDetails!.map((x) => x.toJson())),
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
  String? distance;

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
    this.distance,
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
        distance: json["distance"],
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
        "distance": distance
      };
}

class CompletedDetail {
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
  String? distance;

  CompletedDetail({
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
    this.distance,
  });

  factory CompletedDetail.fromJson(Map<String, dynamic> json) =>
      CompletedDetail(
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
        distance: json["distance"],
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
        "distance": distance
      };
}

class AbortedDetail {
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
  String? distance;

  AbortedDetail(
      {this.id,
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
      this.distance});

  factory AbortedDetail.fromJson(Map<String, dynamic> json) => AbortedDetail(
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
        distance: json["distance"],
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
        "distance": distance,
      };
}
