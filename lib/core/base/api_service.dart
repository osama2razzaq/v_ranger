import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_ranger/core/values/api_constants.dart';
import 'package:v_ranger/features/Survey/data/Model/drop_down_mode.dart';
import 'package:v_ranger/features/batches/data/model/batch_details_model.dart';
import 'package:v_ranger/features/batches/data/model/batches_model.dart';
import 'package:v_ranger/features/dashboard/data/Model/dashboard_model.dart';
import 'package:v_ranger/features/leaderboard/data/Model/leaderboard_details_model.dart';
import 'package:v_ranger/features/profile/data/model/profile_model.dart';

class ApiService {
  Future<http.Response> login(
      String email, String password, String deviceToken) async {
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}');
    print("deviceToken: $deviceToken");
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
    int? driveId = prefs.getInt('driveId');
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary

    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logout}');
    final body = {
      'driver_id': driveId,
    };
    final bodyJson = jsonEncode(body);
    final response = await http.post(
      url,
      body: bodyJson,
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

  Future<BatchDetailsList?> fetchBatchDetailsList(String batchId, String search,
      String driverLatitude, String driverLongitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    int? driveId = prefs.getInt('driveId'); // Adjust the key as necessary

    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getbatchdetails}');

    final body = {
      'driver_id': driveId.toString(),
      'batch_id': batchId,
      'search': search,
      'driver_latitude': driverLatitude,
      'driver_longitude': driverLongitude,
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
        print("updated location ${response.body}");
      } else {
        return response;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<LeaderBoardDetails?> fetchDriversleaderBoard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    int? driveId = prefs.getInt('driveId'); // Adjust the key as necessary

    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.driversleaderboard}');
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
      print("response::: ${response.body}");
      if (response.statusCode == 200) {
        return leaderBoardDetailsFromJson(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
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

  Future<http.Response?> softDeletebatch(String batchId, String action) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.softDeleteBatch}');
    final body = {
      'batch_id': batchId,
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
    bool? hasWaterMeter,
    String? waterMeterNo,
    bool? hasWaterBill,
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
    String? visitDate, // Corrected parameter name to match field
    String? visitTime, // Corrected parameter name to match field
    File? photo1,
    File? photo2,
    File? photo3,
    File? photo4,
    File? photo5,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');
      int? driveId = prefs.getInt('driveId'); // Adjust the key as necessary
      if (token == null) throw Exception('No access token found.');

      final url =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storesurvey}');
      final request = http.MultipartRequest('POST', url)
        ..fields['batch_id'] = batchId
        ..fields['batch_detail_id'] = batchDetailId
        ..fields['user_id'] = driveId.toString()
        ..fields['has_water_meter'] = hasWaterMeter?.toString() ?? ''
        ..fields['water_meter_no'] = waterMeterNo ?? ''
        ..fields['has_water_bill'] = hasWaterBill?.toString() ?? ''
        ..fields['water_bill_no'] = waterBillNo ?? ''
        ..fields['is_correct_address'] = isCorrectAddress?.toString() ?? ''
        ..fields['correct_address'] = correctAddress ?? ''
        ..fields['ownership'] = ownership ?? ''
        ..fields['contact_person_name'] = contactPersonName ?? ''
        ..fields['contact_number'] = contactNumber ?? ''
        ..fields['email'] = email ?? ''
        ..fields['nature_of_business_code'] = natureOfBusinessCode ?? ''
        ..fields['shop_name'] = shopName ?? ''
        ..fields['dr_code'] = drCode ?? ''
        ..fields['property_code'] = propertyCode ?? ''
        ..fields['occupancy'] = occupancy ?? ''
        ..fields['remark'] = remark ?? ''
        ..fields['visitdate'] = visitDate ?? ''
        ..fields['visittime'] = visitTime ?? '';

      // Add files to the request if they are not null
      if (photo1 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo1', photo1.path));
      }
      if (photo2 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo2', photo2.path));
      }
      if (photo3 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo3', photo3.path));
      }
      if (photo4 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo4', photo4.path));
      }
      if (photo5 != null) {
        request.files
            .add(await http.MultipartFile.fromPath('photo5', photo5.path));
      }

      // Add Authorization header
      request.headers['Authorization'] = 'Bearer $token';

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print(responseBody.body);
        return responseBody;
      } else {
        print(responseBody.body);
        return responseBody;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  Future<http.Response?> postSendOTP(String phoneNumber) async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.forgotpassword}');

    final response = await http.post(
      url,
      body: {
        'phone_number': phoneNumber,
      },
    );
    return response;
  }

  Future<http.Response?> postVerifyOTP(
      String phoneNumber, String resetCode) async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.verifyresetcode}');

    final response = await http.post(
      url,
      body: {
        'phone_number': phoneNumber,
        'reset_code': resetCode,
      },
    );
    return response;
  }

  Future<http.Response?> postResetPassword(
      String phoneNumber, String resetCode, String newPassword) async {
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.resetpassword}');
    print(
      phoneNumber,
    );
    print(
      resetCode,
    );
    print(
      newPassword,
    );

    final response = await http.post(
      url,
      body: {
        'phone_number': phoneNumber,
        'reset_code': resetCode,
        'new_password': newPassword,
      },
    );
    return response;
  }

  Future<http.Response?> postChangePassword(
      String oldPassword, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    int? driveId = prefs.getInt('driveId'); // Adjust the key as necessary
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.changepassword}');
    final body = {
      'driver_id': driveId,
      'old_password': oldPassword,
      'new_password': newPassword,
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
        return response;
      } else {
        return response;
      }
    } catch (e) {
      return null;
    }
  }
}
