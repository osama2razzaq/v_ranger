import 'dart:convert';
import 'dart:io';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_ranger/core/values/api_constants.dart';
import 'package:v_ranger/features/Survey/data/Model/drop_down_mode.dart';
import 'package:v_ranger/features/batches/data/model/batch_details_model.dart';
import 'package:v_ranger/features/batches/data/model/batches_model.dart';
import 'package:v_ranger/features/dashboard/data/Model/dashboard_model.dart';
import 'package:v_ranger/features/profile/data/model/profile_model.dart';

class ApiService {
  Future<http.Response> login(
      String email, String password, String deviceToken) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');
    final response = await http.post(
      url,
      body: {
        'username': email,
        'password': password,
        'devicetoken': deviceToken,
      },
    );
    return response;
  }

  Future<http.Response> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary

    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logout}');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    return response;
  }

  Future<DashboardModel?> fetchDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    int? driveId = prefs.getInt('driveId');

    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dashboard}');
    final body = {
      'driver_id': driveId,
    };
    final bodyJson = jsonEncode(body);
    try {
      final response = await http.post(
        url,
        body: bodyJson,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return dashboardModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<ProfileModel?> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    int? driveId = prefs.getInt('driveId');

    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.driverprofile}');
    final body = {
      'driver_id': driveId.toString(),
    };
    final bodyJson = jsonEncode(body);
    try {
      final response = await http.post(
        url,
        body: bodyJson,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return profileModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<BatchesModel?> fetchBatchesData(String batchId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    int? driveId = prefs.getInt('driveId'); // Adjust the key as necessary

    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.batches}');
    final body = {'driver_id': driveId.toString(), 'batch_id': batchId};
    final bodyJson = jsonEncode(body);

    print("bodyJson== $bodyJson");
    try {
      final response = await http.post(
        url,
        body: bodyJson,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return batchesModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<BatchDetailsList?> fetchBatchDetailsList(String batchId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    int? driveId = prefs.getInt('driveId'); // Adjust the key as necessary

    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getbatchdetails}');
    final body = {'driver_id': driveId.toString(), 'batch_id': batchId};
    final bodyJson = jsonEncode(body);
    try {
      final response = await http.post(
        url,
        body: bodyJson,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return batchDetailsListFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<DropdownModel?> fetchDropDownData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary

    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getdropdowns}');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return dropdownModelFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<http.Response?> postUpdateLocation(
      double latitude, double longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    int? driveId = prefs.getInt('driveId'); // Adjust the key as necessary

    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.updatelocation}');
    final body = {
      'driver_id': driveId,
      'latitude': latitude,
      'longitude': longitude,
    };
    final bodyJson = jsonEncode(body);

    try {
      final response = await http.post(
        url,
        body: bodyJson,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
      } else {
        return response;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<http.Response?> updateBatchPin(
      String batchDetailId, String action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    final url = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.updatebatchdetailpin}');
    final body = {
      'batch_detail_id': batchDetailId,
      'action': action,
    };
    final bodyJson = jsonEncode(body);

    try {
      final response = await http.post(
        url,
        body: bodyJson,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
      } else {
        return response;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<http.Response?> postSurvey({
    required String batchId,
    required String batchDetailId,
    required String userId,
    String? waterMeterNo,
    String? waterBillNo,
    bool? isCorrectAddress,
    String? correctAddress,
    String? ownership,
    String? contactPersonName,
    String? contactNumber,
    String? email,
    String? natureOfBusinessCode,
    String? shopName,
    String? drCode,
    String? propertyCode,
    String? occupancy,
    String? remark,
    String? visitDate,
    String? visitTime,
    File? photo1,
    File? photo2,
    File? photo3,
    File? photo4,
    File? photo5,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    int? driveId = prefs.getInt('driveId'); // Adjust the key as necessary

    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storesurvey}');

    final paramBody = {
      'batch_id': batchId,
      'batch_detail_id': batchDetailId,
      'user_id': driveId,
      'water_meter_no': waterMeterNo,
      'water_bill_no': waterBillNo,
      'is_correct_address': isCorrectAddress,
      'correct_address': correctAddress,
      'ownership': ownership,
      'contact_person_name': contactPersonName,
      'contact_number': contactNumber,
      'email': email,
      'nature_of_business_code': natureOfBusinessCode,
      'shop_name': shopName,
      'dr_code': drCode,
      'property_code': propertyCode,
      'occupancy': occupancy,
      'remark': remark,
      'visitdate': visitDate,
      'visittime': visitTime,
      'photo1': photo1 != null
          ? await http.MultipartFile.fromPath('image', photo1.path)
          : null,
      'photo2': photo2 != null
          ? await http.MultipartFile.fromPath('image', photo2.path)
          : null,
      'photo3': photo3 != null
          ? await http.MultipartFile.fromPath('image', photo3.path)
          : null,
      'photo4': photo4 != null
          ? await http.MultipartFile.fromPath('image', photo4.path)
          : null,
      'photo5': photo5 != null
          ? await http.MultipartFile.fromPath('image', photo5.path)
          : null,
    };
    final bodyJson = jsonEncode(paramBody);

    try {
      final response = await http.post(
        url,
        body: bodyJson,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        return response;
      }
    } catch (e) {
      return null;
    }
  }
}
