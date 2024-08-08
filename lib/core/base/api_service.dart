import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_ranger/core/values/api_constants.dart';
import 'package:v_ranger/features/Survey/data/Model/drop_down_mode.dart';
import 'package:v_ranger/features/batches/data/model/batches_model.dart';
import 'package:v_ranger/features/dashboard/data/Model/dashboard_model.dart';

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
    print("logout response== $token");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );
    print("logout response== ${response.body}");
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
        print('Failed to load data');
        return null;
      }
    } catch (e) {
      print('Error: $e');
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

      print('Failed to load data111 ${response.body}');
      if (response.statusCode == 200) {
        return batchesModelFromJson(response.body);
      } else {
        print('Failed to load data111');
        return null;
      }
    } catch (e) {
      print('Error: $e');
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

      print('Failed to load getdropdowns ${response.body}');
      if (response.statusCode == 200) {
        return dropdownModelFromJson(response.body);
      } else {
        print('Failed to load getdropdowns');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
