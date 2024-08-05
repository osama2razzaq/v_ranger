import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:v_ranger/core/values/api_constants.dart';
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

  Future<DashboardModel?> fetchDashboardData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token =
        prefs.getString('access_token'); // Adjust the key as necessary

    final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.dashboard}');
    final body = {
      'driver_id': 1,
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
}
