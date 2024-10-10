import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_ranger/core/values/api_constants.dart';
import 'package:v_ranger/features/Survey/data/Model/Statusdropdown.dart';
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
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    String? detailsString = prefs.getString('details');
    Map<String, dynamic> details = jsonDecode(detailsString!);
    String driverId = details['id'].toString(); // Extract driver_id
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.logout}');
    final body = {
      'driver_id': driverId,
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
    String? detailsString = prefs.getString('details');
    Map<String, dynamic> details = jsonDecode(detailsString!);
    String driverId = details['id'].toString(); // Extract driver_id

    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dashboard}');
    final body = {
      'driver_id': driverId,
    };
    print("body123 $body");
    final bodyJson = jsonEncode(body);

    final connectivityResult = await Connectivity().checkConnectivity();
    // If there's no internet, return cached data
    if (connectivityResult.first == ConnectivityResult.none) {
      String? cachedData = prefs.getString('dashboard_data'); // Cached data
      if (cachedData != null) {
        // Return the cached data if available
        return dashboardModelFromJson(cachedData);
      } else {
        return null; // No internet and no cached data
      }
    }

    // If connected to the internet, fetch from API
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
        // Save API response to local storage
        prefs.setString('dashboard_data', response.body); // Cache the data
        return dashboardModelFromJson(response.body);
      } else if (response.statusCode == 401) {
        return null; // Unauthorized case
      } else {
        return null;
      }
    } catch (e) {
      return null; // Return null on exception
    }
  }

  Future<ProfileModel?> fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    String? detailsString = prefs.getString('details');
    Map<String, dynamic> details = jsonDecode(detailsString!);
    String driverId = details['id'].toString();

    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.driverprofile}');
    final body = {'driver_id': driverId};
    final bodyJson = jsonEncode(body);

    final connectivityResult = await Connectivity().checkConnectivity();

    // If there's no internet, return cached data
    if (connectivityResult.first == ConnectivityResult.none) {
      String? cachedData = prefs.getString('profile_data'); // Cached data
      if (cachedData != null) {
        return profileModelFromJson(cachedData);
      } else {
        return null;
      }
    }

    // If connected to the internet, fetch from API
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
        prefs.setString('profile_data', response.body); // Cache the data
        return profileModelFromJson(response.body);
      } else if (response.statusCode == 401) {
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  // Future<ProfileModel?> fetchProfileData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token =
  //       prefs.getString('access_token'); // Adjust the key as necessary
  //   String? detailsString = prefs.getString('details');
  //   Map<String, dynamic> details = jsonDecode(detailsString!);
  //   String driverId = details['id'].toString(); // Extract driver_id

  //   final url =
  //       Uri.parse('${ApiConstants.baseUrl}${ApiConstants.driverprofile}');
  //   final body = {
  //     'driver_id': driverId.toString(),
  //   };
  //   final bodyJson = jsonEncode(body);
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: bodyJson,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token"
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       return profileModelFromJson(response.body);
  //     } else if (response.statusCode == 401) {
  //       return null;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }

  // Future<BatchesModel?> fetchBatchesData(String batchId) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token =
  //       prefs.getString('access_token'); // Adjust the key as necessary
  //   String? detailsString = prefs.getString('details');
  //   Map<String, dynamic> details = jsonDecode(detailsString!);
  //   String driverId = details['id'].toString(); // Extract driver_id

  //   final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.batches}');
  //   final body = {'driver_id': driverId.toString(), 'batch_id': batchId};
  //   final bodyJson = jsonEncode(body);

  //   print("bodyJson== $bodyJson");
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: bodyJson,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token"
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       return batchesModelFromJson(response.body);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }
  Future<BatchesModel?> fetchBatchesData(String batchId) async {
    // Retrieve SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the access token and driver details
    String? token = prefs.getString('access_token');
    String? detailsString = prefs.getString('details');

    // Ensure detailsString is not null before proceeding
    if (detailsString == null) {
      print("Details string is null.");
      return null;
    }

    Map<String, dynamic> details = jsonDecode(detailsString);
    String driverId = details['id'].toString(); // Extract driver_id

    // Prepare the API endpoint
    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.batches}');

    // Prepare request body
    final body = {
      'driver_id': driverId,
      'batch_id': batchId,
    };
    final bodyJson = jsonEncode(body);

    // Check for internet connectivity
    final connectivityResult = await Connectivity().checkConnectivity();

    // If there's no internet, return cached data
    if (connectivityResult.first == ConnectivityResult.none) {
      String? cachedData = prefs.getString('batches_data'); // Cached data
      if (cachedData != null) {
        return batchesModelFromJson(cachedData);
      } else {
        return null;
      }
    }

    // If connected to the internet, fetch from API
    try {
      final response = await http.post(
        url,
        body: bodyJson,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Handle the response
      if (response.statusCode == 200) {
        prefs.setString('batches_data', response.body); // Cache the data
        return batchesModelFromJson(response.body);
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null; // Handle other errors
      }
    } catch (e) {
      print("Exception occurred: $e");
      return null; // Handle network or parsing errors
    }
  }

  Future<BatchDetailsList?> fetchBatchDetailsList(String batchId, String search,
      String driverLatitude, String driverLongitude) async {
    // Retrieve SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the access token and driver details
    String? token = prefs.getString('access_token');
    String? detailsString = prefs.getString('details');

    // Ensure detailsString is not null before proceeding
    if (detailsString == null) {
      print("Details string is null.");
      return null;
    }

    Map<String, dynamic> details = jsonDecode(detailsString);
    String driverId = details['id'].toString(); // Extract driver_id

    // Prepare the API endpoint
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getbatchdetails}');

    // Prepare request body
    final body = {
      'driver_id': driverId,
      'batch_id': batchId,
      'search': search,
      'driver_latitude': driverLatitude,
      'driver_longitude': driverLongitude,
    };
    final bodyJson = jsonEncode(body);

    // Check for internet connectivity
    final connectivityResult = await Connectivity().checkConnectivity();

    // If there's no internet, return cached data
    if (connectivityResult.first == ConnectivityResult.none) {
      String? cachedData = prefs.getString('batch_details_data'); // Cached data
      if (cachedData != null) {
        return batchDetailsListFromJson(cachedData);
      } else {
        return null;
      }
    }

    // If connected to the internet, fetch from API
    try {
      final response = await http.post(
        url,
        body: bodyJson,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Handle the response
      if (response.statusCode == 200) {
        prefs.setString('batch_details_data', response.body); // Cache the data
        return batchDetailsListFromJson(response.body);
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null; // Handle other errors
      }
    } catch (e) {
      print("Exception occurred: $e");
      return null; // Handle network or parsing errors
    }
  }

  // Future<BatchDetailsList?> fetchBatchDetailsList(String batchId, String search,
  //     String driverLatitude, String driverLongitude) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token =
  //       prefs.getString('access_token'); // Adjust the key as necessary
  //   String? detailsString = prefs.getString('details');
  //   Map<String, dynamic> details = jsonDecode(detailsString!);
  //   String driverId = details['id'].toString(); // Extract driver_id

  //   final url =
  //       Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getbatchdetails}');

  //   final body = {
  //     'driver_id': driverId.toString(),
  //     'batch_id': batchId,
  //     'search': search,
  //     'driver_latitude': driverLatitude,
  //     'driver_longitude': driverLongitude,
  //   };
  //   final bodyJson = jsonEncode(body);
  //   try {
  //     final response = await http.post(
  //       url,
  //       body: bodyJson,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token"
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       return batchDetailsListFromJson(response.body);
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }
  Future<DropdownModel?> fetchDropDownData() async {
    // Retrieve SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the access token
    String? token = prefs.getString('access_token');

    // Prepare the API endpoint
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getdropdowns}');

    // Check for internet connectivity
    final connectivityResult = await Connectivity().checkConnectivity();

    // If there's no internet, return cached data
    if (connectivityResult == ConnectivityResult.none) {
      String? cachedData = prefs.getString('dropdown_data'); // Cached data
      if (cachedData != null) {
        return dropdownModelFromJson(cachedData);
      } else {
        return null;
      }
    }

    // If connected to the internet, fetch from API
    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Handle the response
      if (response.statusCode == 200) {
        prefs.setString('dropdown_data', response.body); // Cache the data
        return dropdownModelFromJson(response.body);
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null; // Handle other errors
      }
    } catch (e) {
      print("Exception occurred: $e");
      return null; // Handle network or parsing errors
    }
  }

  Future<Statusdropdown?> fetchStatusDropdownData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary
    String? detailsString = prefs.getString('details');
    Map<String, dynamic> details = jsonDecode(detailsString!);
    String driverId = details['id'].toString(); // Extract driver_id

    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.statusdropdown}');
    final body = {
      'driver_id': driverId,
    };

    final bodyJson = jsonEncode(body);

    try {
      final response = await http.post(
        url,
        body: bodyJson,
        headers: {
          "Content-Type": "application/json",
          "Authorization": 'Bearer $token'
        },
      );

      if (response.statusCode == 200) {
        return statusdropdownFromJson(response.body);
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
    String? detailsString = prefs.getString('details');
    Map<String, dynamic> details = jsonDecode(detailsString!);
    String driverId = details['id'].toString(); // Extract driver_id

    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.updatelocation}');
    final body = {
      'driver_id': driverId,
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
    // Retrieve SharedPreferences instance
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Get the access token and driver details
    String? token = prefs.getString('access_token');
    String? detailsString = prefs.getString('details');

    // Ensure detailsString is not null before proceeding
    if (detailsString == null) {
      print("Details string is null.");
      return null;
    }

    Map<String, dynamic> details = jsonDecode(detailsString);
    String driverId = details['id'].toString(); // Extract driver_id

    // Prepare the API endpoint
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.driversleaderboard}');

    // Prepare request body
    final body = {'driver_id': driverId};
    final bodyJson = jsonEncode(body);

    // Check for internet connectivity
    final connectivityResult = await Connectivity().checkConnectivity();

    // If there's no internet, return cached data
    if (connectivityResult.first == ConnectivityResult.none) {
      String? cachedData = prefs.getString('leaderboard_data'); // Cached data
      if (cachedData != null) {
        return leaderBoardDetailsFromJson(cachedData);
      } else {
        return null;
      }
    }

    // If connected to the internet, fetch from API
    try {
      final response = await http.post(
        url,
        body: bodyJson,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Handle the response
      if (response.statusCode == 200) {
        prefs.setString('leaderboard_data', response.body); // Cache the data
        return leaderBoardDetailsFromJson(response.body);
      } else if (response.statusCode == 401) {
        print("Unauthorized access. Token might be invalid.");
        return null; // Handle token expiration or invalid token
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        return null; // Handle other errors
      }
    } catch (e) {
      print("Exception occurred: $e");
      return null; // Handle network or parsing errors
    }
  }

  // Future<LeaderBoardDetails?> fetchDriversleaderBoard() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? token =
  //       prefs.getString('access_token'); // Adjust the key as necessary
  //   print(token);
  //   String? detailsString = prefs.getString('details');
  //   Map<String, dynamic> details = jsonDecode(detailsString!);
  //   String driverId = details['id'].toString(); // Extract driver_id

  //   final url =
  //       Uri.parse('${ApiConstants.baseUrl}${ApiConstants.driversleaderboard}');
  //   final body = {
  //     'driver_id': driverId.toString(),
  //   };
  //   final bodyJson = jsonEncode(body);

  //   try {
  //     final response = await http.post(
  //       url,
  //       body: bodyJson,
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Authorization": "Bearer $token"
  //       },
  //     );
  //     print("response::: ${response.body}");
  //     if (response.statusCode == 200) {
  //       return leaderBoardDetailsFromJson(response.body);
  //     } else if (response.statusCode == 401) {
  //       return null;
  //     } else {
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }

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
    required List<String> batchDetailIds,
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
    String? classification,
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
      String? detailsString = prefs.getString('details');
      Map<String, dynamic> details = jsonDecode(detailsString!);
      String driverId = details['id'].toString(); // Extract driver_id
      if (token == null) throw Exception('No access token found.');

      final url =
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.storesurvey}');

      print(
        "token::: $token",
      );
      final request = http.MultipartRequest('POST', url)
        ..fields['batch_id'] = batchId
        ..fields['batch_detail_id'] = jsonEncode(batchDetailIds)
        ..fields['user_id'] = driverId.toString()
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
        ..fields['classification'] = classification ?? ''
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
      print(response);
      final responseBody = await http.Response.fromStream(response);
      print("request::::1 ${request.fields}");
      print("request::::1 ${request.files}");

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
    String? detailsString = prefs.getString('details');
    Map<String, dynamic> details = jsonDecode(detailsString!);
    String driverId = details['id'].toString(); // Extract driver_id
    final url =
        Uri.parse('${ApiConstants.baseUrl}${ApiConstants.changepassword}');
    final body = {
      'driver_id': driverId,
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
