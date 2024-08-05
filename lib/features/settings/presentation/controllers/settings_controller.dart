import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:v_ranger/core/base/api_service.dart';
import 'package:v_ranger/core/routing/app_routes.dart';
import 'package:v_ranger/core/utils/snack_bar_helper.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For local storage

class SettingsController extends GetxController with SnackBarHelper {
  // Observables for email and password
  var email = ''.obs;
  var password = ''.obs;

  // TextEditingController for the input fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Instance of ApiService
  final ApiService apiService =
      ApiService(); // Replace with your actual base URL

  // Device token (for demonstration purposes, this should be retrieved from your device)
  final String deviceToken = '131131';

  // Method to handle login
  void logout() async {
    try {
      final response = await apiService.logout();

      if (response.statusCode == 200) {
        // Parse successful response

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('access_token');
        Get.offAllNamed(Routes.login);

        showNormalSnackBar("Logged out successfully");
      } else {
        // Parse error response
        final responseData = jsonDecode(response.body);
        if (responseData['errors'] != null) {
          // Handle validation errors
          final validationErrors = responseData['errors'];
          final errorMessage = validationErrors.isNotEmpty
              ? validationErrors.values.first.join(', ')
              : 'Unknown error';
          showErrorSnackBar("Error: $errorMessage");
        } else {
          // Handle general error
          final errorMessage = responseData['message'] ?? 'Unknown error';
          showErrorSnackBar("Error: $errorMessage");
        }

        // Save error message and status code locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('error_status_code', response.statusCode);
        await prefs.setString(
            'error_message', responseData['message'] ?? 'Unknown error');
      }
    } catch (e) {
      // Handle any errors that occur during the API call
      showErrorSnackBar("An error occurred: $e");

      // Save error message and status code locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('error_status_code', -1); // -1 indicates an exception
      await prefs.setString('error_message', e.toString());
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
