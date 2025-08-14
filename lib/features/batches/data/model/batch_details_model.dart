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

  copyWith(
      {required List<PendingDetail> pendingDetails,
      required int pendingCount}) {}
}

class PendingDetail {
  int? id;
  int? batchId;
  int? fileid;
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
  dynamic distance;

  PendingDetail({
    this.id,
    this.batchId,
    this.fileid,
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
        fileid: json["fileid"],
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
        "fileid": fileid,
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
  int? fileid;
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
  dynamic distance;
  Survey? survey; // Add the survey field here

  CompletedDetail({
    this.id,
    this.batchId,
    this.fileid,
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
    this.survey, // Include in constructor
  });

  factory CompletedDetail.fromJson(Map<String, dynamic> json) =>
      CompletedDetail(
        id: json["id"],
        batchId: json["batch_id"],
        fileid: json["fileid"],
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
        survey: json["survey"] == null
            ? null
            : Survey.fromJson(json["survey"]), // Parsing survey
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "batch_id": batchId,
        "fileid": fileid,
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
        "survey": survey?.toJson(), // Serialize survey
      };
}

class Survey {
  int? id;
  int? batchId;
  int? batchDetailId;
  int? userId;
  String? hasWaterMeter;
  String? waterMeterNo;
  String? hasWaterBill;
  String? waterBillNo;
  String? isCorrectAddress;
  String? correctAddress;
  String? ownership;
  String? contactPersonName;
  String? contactNumber;
  String? email;
  String? natureOfBusinessCode;
  String? shopName;
  String? drCode;
  String? propertyCode;
  String? occupancy;
  String? classification;
  String? remark;
  String? visitdate;
  String? visittime;
  String? photo1;
  String? photo2;
  String? photo3;
  String? photo4;
  String? photo5;
  String? createdAt;
  String? updatedAt;

  Survey({
    this.id,
    this.batchId,
    this.batchDetailId,
    this.userId,
    this.hasWaterMeter,
    this.waterMeterNo,
    this.hasWaterBill,
    this.waterBillNo,
    this.isCorrectAddress,
    this.correctAddress,
    this.ownership,
    this.contactPersonName,
    this.contactNumber,
    this.email,
    this.natureOfBusinessCode,
    this.shopName,
    this.drCode,
    this.propertyCode,
    this.occupancy,
    this.classification,
    this.remark,
    this.visitdate,
    this.visittime,
    this.photo1,
    this.photo2,
    this.photo3,
    this.photo4,
    this.photo5,
    this.createdAt,
    this.updatedAt,
  });

  factory Survey.fromJson(Map<String, dynamic> json) => Survey(
        id: json["id"],
        batchId: json["batch_id"],
        batchDetailId: json["batch_detail_id"],
        userId: json["user_id"],
        hasWaterMeter: json["has_water_meter"],
        waterMeterNo: json["water_meter_no"],
        hasWaterBill: json["has_water_bill"],
        waterBillNo: json["water_bill_no"],
        isCorrectAddress: json["is_correct_address"],
        correctAddress: json["correct_address"],
        ownership: json["ownership"],
        contactPersonName: json["contact_person_name"],
        contactNumber: json["contact_number"],
        email: json["email"],
        natureOfBusinessCode: json["nature_of_business_code"],
        shopName: json["shop_name"],
        drCode: json["dr_code"],
        propertyCode: json["property_code"],
        occupancy: json["occupancy"],
        classification: json["classification"],
        remark: json["remark"],
        visitdate: json["visitdate"],
        visittime: json["visittime"],
        photo1: json["photo1"],
        photo2: json["photo2"],
        photo3: json["photo3"],
        photo4: json["photo4"],
        photo5: json["photo5"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "batch_id": batchId,
        "batch_detail_id": batchDetailId,
        "user_id": userId,
        "has_water_meter": hasWaterMeter,
        "water_meter_no": waterMeterNo,
        "has_water_bill": hasWaterBill,
        "water_bill_no": waterBillNo,
        "is_correct_address": isCorrectAddress,
        "correct_address": correctAddress,
        "ownership": ownership,
        "contact_person_name": contactPersonName,
        "contact_number": contactNumber,
        "email": email,
        "nature_of_business_code": natureOfBusinessCode,
        "shop_name": shopName,
        "dr_code": drCode,
        "property_code": propertyCode,
        "occupancy": occupancy,
        "classification": classification,
        "remark": remark,
        "visitdate": visitdate,
        "visittime": visittime,
        "photo1": photo1,
        "photo2": photo2,
        "photo3": photo3,
        "photo4": photo4,
        "photo5": photo5,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class AbortedDetail {
  int? id;
  int? batchId;
  int? fileid;
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
  dynamic distance;

  AbortedDetail(
      {this.id,
      this.batchId,
      this.fileid,
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
        fileid: json["fileid"],
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
        "fileid": fileid,
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
